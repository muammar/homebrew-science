class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  revision 2

  stable do
    url "https://ftpmirror.gnu.org/octave/octave-4.0.3.tar.gz"
    sha256 "5a16a42fca637ae1b55b4a5a6e7b16a6df590cbaeeb4881a19c7837789515ec6"

    # Fix alignment of dock widget titles for OSX (bug #46592)
    # See: http://savannah.gnu.org/bugs/?46592
    patch do
      url "http://hg.savannah.gnu.org/hgweb/octave/raw-rev/e870a68742a6"
      sha256 "0ddcd8dd032be79d5a846ad2bc190569794e4e1a33ce99f25147d70ae6974682"
    end

    # Fix bug #48407: libinterp fails to link to libz
    patch :p0 do
      url "http://savannah.gnu.org/bugs/download.php?file_id=37717"
      sha256 "feeaad0d00be3008caef2162b549c42fd937f3fb02a36d01cde790a589d4eb2d"
    end
  end

  bottle do
    sha256 "19a9fab6c3331589ff50de4e5e5e16c75b1eee77a6e81460db7b283c9f4c512f" => :el_capitan
    sha256 "99e4345ff41469ef9b318f2ef2ef81efc0b933ce3b0973533c1ea1f46cb81cd5" => :yosemite
    sha256 "cb18d800c5d8eda1aed272caf41d3b77adaf539d42800a92c91cf2dba649a11e" => :mavericks
  end

  if OS.mac? && DevelopmentTools.clang_version < "7.0"
    # Fix the build error with LLVM 3.5svn (-3.6svn?) and libc++ (bug #43298)
    # See: http://savannah.gnu.org/bugs/?43298
    patch do
      url "http://savannah.gnu.org/bugs/download.php?file_id=32255"
      sha256 "ef83b32384a37cca13ecdd30d98dacac314b7c23f2c1df3d1113074bd1169c0f"
    end
    # Fixes includes "base-list.h" and "config.h" in comment-list.h and "oct.h" (bug #41027)
    # Core developers don't like this fix, see: http://savannah.gnu.org/bugs/?41027
    patch do
      url "http://savannah.gnu.org/bugs/download.php?file_id=31400"
      sha256 "efdf91390210a64e4732da15dcac576fb1fade7b85f9bacf4010d102c1974729"
    end
  end

  # dependencies needed for head
  # "librsvg" and ":tex" are currently not necessary
  # since we do not build the pdf docs
  head do
    url "http://www.octave.org/hg/octave", :branch => "default", :using => :hg
    depends_on :hg             => :build
    depends_on "autoconf"      => :build
    depends_on "automake"      => :build
    depends_on "bison"         => :build
    depends_on "icoutils"      => :build
    depends_on "librsvg"        => :build

    # Fix bug #46723: retina scaling of buttons
    # see https://savannah.gnu.org/bugs/?46723
    patch :p1 do
      url "https://savannah.gnu.org/bugs/download.php?file_id=38206"
      sha256 "8307cec2b84fe546c8f490329b488ecf1da628ce823301b6765ffa7e6e292eed"
    end
  end

  skip_clean "share/info" # Keep the docs

  # deprecated options
  deprecated_option "without-check" => "without-test"

  # options, enabled by default
  option "without-curl",           "Do not use cURL (urlread/urlwrite/@ftp)"
  option "without-fftw",           "Do not use FFTW (fft,ifft,fft2,etc.)"
  option "without-fltk",           "Do not use FLTK graphics backend"
  option "without-glpk",           "Do not use GLPK"
  option "without-gnuplot",        "Do not use gnuplot graphics"
  option "without-hdf5",           "Do not use HDF5 (hdf5 data file support)"
  option "without-opengl",         "Do not use opengl"
  option "without-qhull",          "Do not use the Qhull library (delaunay,voronoi,etc.)"
  option "without-qrupdate",       "Do not use the QRupdate package (qrdelete,qrinsert,qrshift,qrupdate)"
  option "without-suite-sparse",   "Do not use SuiteSparse (sparse matrix operations)"
  option "without-test",           "Do not perform build-time tests (not recommended)"
  option "without-zlib",           "Do not use zlib (compressed MATLAB file formats)"

  # options, disabled by default
  option "with-audio",             "Use the sndfile and portaudio libraries for audio operations"
  option "with-docs",              "Compile and install documentation"
  option "with-gui",               "Compile with graphical user interface"
  option "with-java",              "Use Java, requires Java 6 from https://support.apple.com/kb/DL1572"
  option "with-jit",               "Use the experimental just-in-time compiler (not recommended)"
  option "with-openblas",          "Use OpenBLAS instead of native LAPACK/BLAS"
  option "with-osmesa",            "Use the OSmesa library (incompatible with opengl)"

  # build dependencies
  depends_on "gnu-sed"         => :build
  depends_on "pkg-config"      => :build

  # essential dependencies
  depends_on :fortran
  depends_on :x11
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "texinfo"         => :build # we need >4.8
  depends_on "pcre"

  # recommended dependencies (implicit options)
  depends_on "readline"       => :recommended
  depends_on "arpack"         => :recommended
  depends_on "epstool"        => :recommended
  depends_on "ghostscript"    => :recommended  # ps/pdf image output
  depends_on "gl2ps"          => :recommended
  depends_on "graphicsmagick" => :recommended  # imread/imwrite
  depends_on "transfig"       => :recommended

  # conditional dependecies (explicit options)
  depends_on "curl"            if build.with?("curl") && MacOS.version == :leopard
  depends_on "fftw"            if build.with? "fftw"
  depends_on "fltk"            if build.with? "fltk"
  depends_on "glpk"            if build.with? "glpk"
  depends_on "gnuplot"         if build.with? "gnuplot"
  depends_on "hdf5"            if build.with? "hdf5"
  depends_on :java => "1.6+"   if build.with? "java"
  depends_on "llvm"            if build.with? "jit"
  depends_on "pstoedit"        if build.with? "ghostscript"
  depends_on "qhull"           if build.with? "qhull"
  depends_on "qrupdate"        if build.with? "qrupdate"
  depends_on "suite-sparse"    if build.with? "suite-sparse"
  depends_on "libsndfile"      if build.with? "audio"
  depends_on "portaudio"       if build.with? "audio"
  depends_on "veclibfort"      if build.without? "openblas"
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)

  # Qt5 support is only available with Octave >=4.2
  if build.with?("gui") && build.head?
    depends_on "qscintilla2"
    depends_on "qt5"
  elsif build.with?("gui")
    odie "Homebrew dropped support of Qt4 but Octave 4.2 is not yet released.
       If you need the GUI, you may try installing with --HEAD"
  end

  # If GraphicsMagick was built from source, it is possible that it was
  # done to change quantum depth. If so, our Octave bottles are no good.
  # https://github.com/Homebrew/homebrew-science/issues/2737
  if build.with? "graphicsmagick"
    def pour_bottle?
      Tab.for_name("graphicsmagick").bottle?
    end
  end

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"
    ENV.append "LDFLAGS", "-L#{Formula["readline"].opt_lib} -lreadline" if build.with? "readline"
    ENV.prepend_path "PATH", Formula["texinfo"].bin
    ENV["FONTCONFIG_PATH"] = "/opt/X11/lib/X11/fontconfig"

    # make sure qt5 is found
    if build.with?("gui")
      ENV.prepend_path "PATH", Formula["qt5"].bin
    end

    # basic arguments
    args = ["--prefix=#{prefix}"]
    args << "--enable-dependency-tracking"
    args << "--enable-link-all-dependencies"
    args << "--enable-shared"
    args << "--disable-static"
    args << "--with-x=no" if OS.mac? # We don't need X11 for Mac at all

    # arguments for options enabled by default
    args << "--without-curl"             if build.without? "curl"
    args << "--disable-docs"             if build.without? "docs"
    args << "--without-fftw3"            if build.without? "fftw"
    args << "--with-fltk-prefix=#{Formula["fltk"].opt_prefix}" if build.with? "fltk"
    args << "--without-glpk"             if build.without? "glpk"
    args << "--disable-gui"              if build.without? "gui"
    args << "--without-opengl"           if build.without? "opengl"
    args << "--without-framework-opengl" if build.without? "opengl"
    args << "--without-OSMesa"           if build.without? "osmesa"
    args << "--without-qhull"            if build.without? "qhull"
    args << "--without-qrupdate"         if build.without? "qrupdate"
    args << "--disable-readline"         if build.without? "readline"
    args << "--without-zlib"             if build.without? "zlib"

    # arguments for options disabled by default
    args << "--with-portaudio"           if build.without? "audio"
    args << "--with-sndfile"             if build.without? "audio"
    args << "--disable-java"             if build.without? "java"
    args << "--enable-jit"               if build.with? "jit"

    # ensure that the right hdf5 library is used
    if build.with? "hdf5"
      args << "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}"
      args << "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}"
    else
      args << "--without-hdf5"
    end

    # arguments if building without suite-sparse
    if build.without? "suite-sparse"
      args << "--without-amd"
      args << "--without-camd"
      args << "--without-colamd"
      args << "--without-ccolamd"
      args << "--without-cxsparse"
      args << "--without-camd"
      args << "--without-cholmod"
      args << "--without-umfpack"
    else
      ENV.append_to_cflags "-L#{Formula["suite-sparse"].opt_lib} -lsuitesparseconfig"
      ENV.append_to_cflags "-L#{Formula["metis"].opt_lib} -lmetis"
    end

    # check if openblas settings are compatible
    if build.with? "openblas"
      if ["arpack", "qrupdate", "suite-sparse"].any? { |n| Tab.for_name(n).without? "openblas" }
        odie "Octave is compiled --with-openblas but arpack, qrupdate or suite-sparse are not."
      else
        args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas"
      end
    elsif OS.mac? # without "openblas"
      if ["arpack", "qrupdate", "suite-sparse"].any? { |n| Tab.for_name(n).with? "openblas" }
        odie "Arpack, qrupdate or suite-sparse are compiled --with-openblas but Octave is not."
      else
        args << "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lveclibFort"
      end
    else # OS.linux? and without "openblas"
      args << "-lblas -llapack"
    end

    system "./bootstrap" if build.head?

    stable do # can be dropped with Octave >=4.2
      # libtool needs to see -framework to handle dependencies better.
      inreplace "configure", "-Wl,-framework -Wl,", "-framework "

      # the Mac build configuration passes all linker flags to mkoctfile to
      # be inserted into every oct/mex build. This is actually unnecessary and
      # can cause linking problems.
      inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'
    end

    system "./configure", *args
    system "make", "all"
    system "make", "check" if build.with? "test"
    system "make", "install"

    prefix.install "test/fntests.log" if File.exist? "test/fntests.log"
  end

  def caveats
    s = ""

    if build.with?("gui")
      s += <<-EOS.undent

      Octave is compiled with a graphical user interface. The start-up option --no-gui
      will run the familiar command line interface. The option --no-gui-libs runs a
      minimalistic command line interface that does not link with the Qt libraries and
      uses the fltk toolkit for plotting if available.

      EOS

    else

      s += <<-EOS.undent

      Octave's graphical user interface is disabled; compile Octave with the option
      --with-gui to enable it.

      EOS

    end

    if build.with?("gnuplot") || build.with?("fltk")
      s += <<-EOS.undent

        Several graphics toolkit are available. You can select them by using the command
        'graphics_toolkit' in Octave.  Individual Gnuplot terminals can be chosen by setting
        the environment variable GNUTERM and building gnuplot with the following options:

          setenv('GNUTERM','qt')    # Requires QT; install gnuplot --with-qt5
          setenv('GNUTERM','x11')   # Requires XQuartz; install gnuplot --with-x11
          setenv('GNUTERM','wxt')   # Requires wxmac; install gnuplot --with-wxmac
          setenv('GNUTERM','aqua')  # Requires AquaTerm; install gnuplot --with-aquaterm

        You may also set this variable from within Octave. For printing the cairo backend
        is recommended, i.e., install gnuplot with --with-cairo, and use

          print -dpdfcairo figure.pdf

      EOS
    end

    if build.without?("osmesa") || (build.with?("osmesa") && build.with?("opengl"))
      s += <<-EOS.undent

      When using the native Qt or fltk toolkits then invisible figures do not work because
      osmesa is incompatible with Mac's OpenGL. The usage of gnuplot is recommended.

      EOS
    end

    s += "\n" unless s.empty?
    s
  end

  test do
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # this is supposed to crash octave if there is a problem with veclibfort
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
  end
end
