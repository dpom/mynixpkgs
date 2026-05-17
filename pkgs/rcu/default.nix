{
  lib,
  stdenv,
  python3,
  qt5,
  requireFile,
}:
let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      pyqt5 # Interfața grafică prin proxy local
      paramiko # SSH pentru tableta reMarkable
      pillow # Procesare de imagini
      pikepdf # Suport PDF conform cerințelor de build
      protobuf # Suport metadate firmware (mod Pure-Python configurat mai jos)
      certifi # Adăugat pentru a rezolva eroarea "No module named 'certifi'"
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "rcu";
  version = "4.0.34";

  src = requireFile {
    name = "rcu-${version}-source.tar.gz";
    sha256 = "sha256-9YhhsLqAcevjJmENWVWfA1ursPz3mgFz8mzLLSNlXVM=";
    url = "https://files.davisr.me/projects/rcu/";
    message = ''
      Descarca manual sursa si adaug-o cu:
      nix-store --add-fixed sha256 rcu-source.tar.gz
    '';
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    pythonEnv
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rcu
    cp -r * $out/share/rcu

    # Creăm folderul pentru pachetul virtual PySide2
    mkdir -p $out/share/rcu/src/PySide2

    # Generăm un __init__.py complet inteligent (Qt proxy + Paramiko fixes + TypeError int/float fixes complet)
    cat <<EOF > $out/share/rcu/src/PySide2/__init__.py
    import PyQt5.QtCore as QtCore
    import PyQt5.QtWidgets as QtWidgets
    import PyQt5.QtGui as QtGui
    import PyQt5.QtSvg as QtSvg
    import PyQt5.QtNetwork as QtNetwork
    import PyQt5.QtPrintSupport as QtPrintSupport
    import PyQt5.uic as uic
    import sys
    import types
    import functools
    import errno

    # 1. Injectăm alias-urile pentru compatibilitate în QtCore
    if not hasattr(QtCore, 'Slot'):
        QtCore.Slot = QtCore.pyqtSlot
    if not hasattr(QtCore, 'Signal'):
        QtCore.Signal = QtCore.pyqtSignal

    # 2. Rezolvare QMatrix
    if not hasattr(QtGui, 'QMatrix'):
        QtGui.QMatrix = QtGui.QTransform

    # 3. Rezolvare "TypeError: unhashable type: 'CollectionTreeWidgetItem'"
    if hasattr(QtWidgets, 'QTreeWidgetItem'):
        QtWidgets.QTreeWidgetItem.__hash__ = lambda self: id(self)

    # 4. Rezolvare "TypeError: argument 1 has unexpected type 'float'" pentru dimensiuni și bare de progres
    if hasattr(QtWidgets, 'QWidget'):
        orig_setFixedWidth = QtWidgets.QWidget.setFixedWidth
        orig_setFixedHeight = QtWidgets.QWidget.setFixedHeight

        @functools.wraps(orig_setFixedWidth)
        def custom_setFixedWidth(self, w):
            return orig_setFixedWidth(self, int(w) if isinstance(w, (float, int)) else w)

        @functools.wraps(orig_setFixedHeight)
        def custom_setFixedHeight(self, h):
            return orig_setFixedHeight(self, int(h) if isinstance(h, (float, int)) else h)

        QtWidgets.QWidget.setFixedWidth = custom_setFixedWidth
        QtWidgets.QWidget.setFixedHeight = custom_setFixedHeight

    # Injectăm conversia float -> int și pentru setValue în QProgressBar (rezolvă eroarea bateriei)
    if hasattr(QtWidgets, 'QProgressBar'):
        orig_setValue = QtWidgets.QProgressBar.setValue

        @functools.wraps(orig_setValue)
        def custom_setValue(self, val):
            return orig_setValue(self, int(round(val)) if isinstance(val, (float, int)) else val)

        QtWidgets.QProgressBar.setValue = custom_setValue

    # 5. Construim dinamic submodulul QtUiTools pentru fișierele .ui
    qtuitools_mod = types.ModuleType('PySide2.QtUiTools')
    class CustomUiLoader:
        def load(self, file_obj, parent=None):
            file_path = file_obj
            if hasattr(file_obj, 'fileName'):
                file_path = file_obj.fileName()
            elif hasattr(file_obj, 'name'):
                file_path = file_obj.name
            return uic.loadUi(file_path, parent)
    qtuitools_mod.QUiLoader = CustomUiLoader

    # Mapăm modulele în cache-ul global Python
    sys.modules['PySide2.QtCore'] = QtCore
    sys.modules['PySide2.QtWidgets'] = QtWidgets
    sys.modules['PySide2.QtGui'] = QtGui
    sys.modules['PySide2.QtSvg'] = QtSvg
    sys.modules['PySide2.QtNetwork'] = QtNetwork
    sys.modules['PySide2.QtPrintSupport'] = QtPrintSupport
    sys.modules['PySide2.QtUiTools'] = qtuitools_mod

    # 6. Rezolvare Paramiko DSSKey
    try:
        from paramiko.pkey import PKey
    except ImportError:
        class PKey: pass

    dsskey_mod = types.ModuleType('paramiko.dsskey')
    class DSSKey(PKey): pass
    dsskey_mod.DSSKey = DSSKey
    sys.modules['paramiko.dsskey'] = dsskey_mod

    # 7. Rezolvare Paramiko py3compat lipsă
    py3compat_mod = types.ModuleType('paramiko.py3compat')
    py3compat_mod.string_types = (str,)
    py3compat_mod.long = int
    py3compat_mod.byte_ord = lambda b: b
    py3compat_mod.b = lambda s: s.encode('utf-8') if isinstance(s, str) else s
    py3compat_mod.input = input
    py3compat_mod.PY2 = False
    sys.modules['paramiko.py3compat'] = py3compat_mod

    # 8. Rezolvare 'retry_on_signal' din paramiko.util
    import paramiko.util
    def custom_retry_on_signal(function):
        @functools.wraps(function)
        def retry_wrapper(*args, **kwargs):
            while True:
                try:
                    return function(*args, **kwargs)
                except (OSError, IOError) as e:
                    if e.errno != errno.EINTR:
                        raise
        return retry_wrapper
    paramiko.util.retry_on_signal = custom_retry_on_signal
    EOF

    # Creăm fișierele proxy fizice pentru importurile Qt de tip direct
    echo "from PySide2 import QtCore" > $out/share/rcu/src/PySide2/QtCore.py
    echo "from PySide2 import QtWidgets" > $out/share/rcu/src/PySide2/QtWidgets.py
    echo "from PySide2 import QtGui" > $out/share/rcu/src/PySide2/QtGui.py
    echo "from PySide2 import QtSvg" > $out/share/rcu/src/PySide2/QtSvg.py
    echo "from PySide2 import QtNetwork" > $out/share/rcu/src/PySide2/QtNetwork.py
    echo "from PySide2 import QtPrintSupport" > $out/share/rcu/src/PySide2/QtPrintSupport.py
    echo "from PySide2 import QtUiTools" > $out/share/rcu/src/PySide2/QtUiTools.py

    mkdir -p $out/bin

    # Scriptul de lansare rulează din folderul src
    cat <<EOF > $out/bin/rcu
    #!/bin/sh
    export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
    cd "$out/share/rcu/src"
    exec ${pythonEnv}/bin/python "main.py" "\$@"
    EOF

    chmod +x $out/bin/rcu

    runHook postInstall
  '';

  dontWrapQtApps = false;

  preFixup = ''
    wrapQtApp $out/bin/rcu
  '';

  meta = with lib; {
    description = "reMarkable Connection Utility (RCU)";
    homepage = "https://www.davisr.me/projects/rcu/";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
  };
}
