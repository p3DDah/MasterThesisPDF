%--- Identification ------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}

% +-----------------------------------------------------------+
% | Base packages used for internal processing and validation |
% +-----------------------------------------------------------+
\RequirePackage{xparse}
\RequirePackage{ifthen}
\RequirePackage{iflang}

% +--------------------------------+
% | Set up sbmthesis class options |
% +--------------------------------+
% Class options typically used to pass options to packages.
% Setup a key-value family using the kvoptions package with the prefix SBMT@. This prefix is used throughout this document for internal variables or commands.
\RequirePackage{kvoptions}
\SetupKeyvalOptions{%
    family=SBMT,%
    prefix=SBMT@%
}

% Declare class options
\DeclareStringOption[de]{language}				% default language is german
\DeclareStringOption[twoside]{layout} 			% default is set to two-sided 
\DeclareBoolOption[false]{titlepage}			% boolean for titlepage(s)
\DeclareBoolOption[false]{preamble}				% boolean for preamble
\DeclareBoolOption[false]{draftmode}			% boolean for draft mode
\ProcessKeyvalOptions*

% +--------------------------+
% | Class options evaluation |
% +--------------------------+
% Base evaluation command that verifies that the class options where correctly set by the user
\newcommand*{\SBMT@evaluate}[1]{%
    % Check, if option value in \<prefix>@<option> exists
    \@ifundefined{SBMT@#1}{%
        % Should not happen
        \PackageError{SBMT}{Evaluating unknown option `#1'}\@ehc
    }{%
        % Check, if there is an implementation for the value of the option
        % in macro \<prefix>@<option>@<value>
        \@ifundefined{SBMT@#1@\csname SBMT@#1\endcsname}{%
            \ClassError{SBMT}{%
                Invalid option setting: #1=%
                \csname SBMT@#1\endcsname
            }\@ehc
        }{%
            % Call the implementation for the value
            \csname SBMT@#1@%
            \csname SBMT@#1\endcsname
            \endcsname
            \relax
        }%
    }%
}

\@namedef{SBMT@language@en}{%
    \PassOptionsToPackage{ngerman, english}{babel}
}

% Do the same for one- or two-sided documents
\@namedef{SBMT@layout@twoside}{%
    \PassOptionsToClass{twoside}{scrbook}
}

% Validate the class options values set by the user
\SBMT@evaluate{language}
\SBMT@evaluate{layout}

% if draft mode is enabled (true) pass option "draft" to class
\ifthenelse{\boolean{SBMT@draftmode}}{%
    	\PassOptionsToClass{draft}{scrbook}
    	\PassOptionsToPackage{draft}{graphicx}
    }{}

% +---------------------------------------+
% | Load and configure base class scrbook |
% +---------------------------------------+
\LoadClass[
    fontsize=12pt,				% default font size
    DIV=12,						% segmentation of the page
    BCOR=10mm,					% binding adjustment
    numbers=noenddot,           % No end dot behind numberings
    open=right,					% start new chapters on odd pages
    cleardoublepage=empty,		% hide numbering on empty pages
    parskip=half-,              % Paragraph skip of 1/2 baselineskip
    listof=totoc,				% add lists of figures and tables to toc
    bibliography=totoc,			% add bibliography entry to table of contents
    headinclude=true,			% include header to text body or not
    footinclude=false,			% include footer to text body or not
    chapterprefix=false,		% chapter title without prefix
    headings=normal				% size of chapter headings
]{scrbook}
\renewcommand*\chapterheadstartvskip{\vspace*{-\topskip}}
% \usepackage{scrhack} % fix issues with packages that use an older version 

% +----------------------------------------------------------------+
% | Load packages that this class requires or that might be useful | 
% +----------------------------------------------------------------+

% Basics
\RequirePackage[utf8]{inputenc}
\RequirePackage[english]{babel}
\RequirePackage[babel=true,protrusion=true,expansion=true]{microtype}
\RequirePackage{enumitem}
\RequirePackage{siunitx}

% Graphics
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage[singlelinecheck=true]{caption}
\RequirePackage{subcaption}
\RequirePackage{pdfpages}
\definecolor{gray50}{gray}{0.5}

% Fonts 
% (Helvetica as sans serif font, zlmtt as mono spaced font,
% isomath as math font, textcomp and fontawesome for symbols).
% The fonts are scaled so that the heights of the big letter M match.
\RequirePackage[T1]{fontenc}
\RequirePackage[scaled=0.95]{helvet}
\renewcommand\familydefault{\sfdefault}
\RequirePackage[scaled=1.15]{zlmtt}
\usepackage[shortcuts]{extdash}

% Math related packages
\RequirePackage{amsmath}
\allowdisplaybreaks	% Allow line breaks in formulae that span over multiple pages

% Redefine math text command to use the math serif font instead
% of the default sans-serif text font.
\let\oldtext\text
\renewcommand{\text}[1]{\oldtext{\textrm{#1}}}

% Tables
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{tabu}
\RequirePackage{makecell}
\renewcommand\cellalign{tl} % top-left alignment for makecell

% Quotes
\RequirePackage[autostyle=true,babel=true]{csquotes}

% Code listings with a default style
\RequirePackage{listings}

\lstset{
    inputencoding=utf8,
    basicstyle=\ttfamily,
    breaklines=true,
    breakatwhitespace=false,
    postbreak={\hbox{\textcolor{gray50}{\rotatebox[origin=c]{180}{$\Lsh$}}}},
    breakindent=20pt,
    breakautoindent=true,
    tabsize=3,
    title=\lstname,
    captionpos=b,
    backgroundcolor=\color{black!2.5!white},
    tabsize=3,
    basicstyle=\ttfamily\lst@ifdisplaystyle\scriptsize\fi,
    keywordstyle=\color[rgb]{0,0,1},
    commentstyle=\color[rgb]{0.133,0.545,0.133},
    stringstyle=\color[rgb]{0.627,0.126,0.941},
    numberstyle=\normalfont\tiny\color[rgb]{0.75, 0.75, 0.75},
    showstringspaces=false,
    showtabs=false,
    showspaces=false,
    showstringspaces=false,
    numbers=left,
    numberstyle=\tiny,
    frame=tb,
    xleftmargin=0.75cm,
    framexleftmargin=0.75cm,
    framexrightmargin=0cm,
    framerule=0.5pt,
    rulecolor=\color{lightgray},
    numberstyle=\normalfont\tiny\color{gray},
    aboveskip=\baselineskip,
    belowskip=0cm,
    abovecaptionskip=.5\baselineskip,
    belowcaptionskip=.5\baselineskip
}

\lstset{literate=%
    {Ö}{{\"O}}1
    {Ä}{{\"A}}1
    {Ü}{{\"U}}1
    {ß}{{\ss}}1
    {ü}{{\"u}}1
    {ä}{{\"a}}1
    {ö}{{\"o}}1
    {~}{{\textasciitilde}}1
}

% Line spacing
\RequirePackage{setspace}
\setstretch{1.1} 

% +-------------------------------------------------------+
% | Load additional packages here using \RequirePackage{} |
% +-------------------------------------------------------+

%%% --- %%%

% Hyperlinks
\RequirePackage[hyphens]{url}
\urlstyle{tt}
\RequirePackage[bookmarks=true,backref,pagebackref=false]{hyperref}
\hypersetup{%
				hidelinks,
                bookmarksopen=false,
                bookmarksnumbered=true,
                pdfpagemode=UseOutlines}
\KOMAoptions{bookmarkpackage=false}

% Acronyms and abbreviations
\RequirePackage[toc]{glossaries}
\setlength{\glsdescwidth}{15cm}
\glsaddkey{unit}{\glsentrytext{\glslabel}}{\glsentryunit}{\GLsentryunit}{\glsunit}{\Glsunit}{\GLSunit}
\makeglossaries
\input{mandatory/symbols}
\newglossarystyle{symbunitlong}{%
\setglossarystyle{long3col}% base this style on the list style
\renewenvironment{theglossary}{% Change the table type --> 3 columns
  \begin{longtable}{lp{0.6\glsdescwidth}>{\centering\arraybackslash}p{2cm}}}%
  {\end{longtable}}%
%
\renewcommand*{\glossaryheader}{%  Change the table header
  \bfseries Sign & \bfseries Description & \bfseries Unit \\
  \hline
  \endhead}
\renewcommand*{\glossentry}[2]{%  Change the displayed items
\glstarget{##1}{\glossentryname{##1}} %
& \glossentrydesc{##1}% Description
& \glsunit{##1}  \tabularnewline
}
}

\usepackage{acro}[=v2]

\acsetup{display-foreign = false}
\acsetup{foreign-format = {\scshape}}

%%begin novalidate
\ExplSyntaxOn
    \prop_new:N \l__acro_foreign_format_prop
\ExplSyntaxOff
%%end novalidate

\newlist{acrolist}{description}{1}
\setlist[acrolist]{
  itemsep=0.5\baselineskip,
  parsep=0pt,
  topsep=0pt,
  partopsep=0pt,
  leftmargin=0.5em
}

% 1. Declare the list style (structure only)
\DeclareAcroListStyle{mylist}{list}{
  list = acrolist
}

\DeclareAcroExtraStyle{newline}{inline}{
  punct        = true,
  punct-symbol = {\newline}, % Use \newline as the separator.
  brackets     = false
}

% CORRECTED: \acsetup applies the formats globally.
\acsetup{
  hyperref          = true,
  list-style        = mylist,
  list-heading      = section*,
  sort              = true,
  list-name         = Acronyms,
  single            = true,
  % --- Apply formatting here ---
  list-short-format = \bfseries, % Makes the short form bold in the list.
  extra-style       = newline,   % Use the custom style to add the line break.
  extra-format      = \itshape,   % Makes the extra information italic.
}

% KOMA Script related
\KOMAoptions{cleardoublepage=empty}		% Do not print anything on empty pages
\addtokomafont{chapterentrydots}{\bfseries}
\addtokomafont{descriptionlabel}{\normalfont\bfseries}

%%% Document configuration
% Depth of table of contents
\setcounter{tocdepth}{2}

% Depth of chapter numbering
\setcounter{secnumdepth}{2}

% +-----------------+
% | Layout settings |
% +-----------------+
\usepackage{scrlayer-scrpage}

% Basics
\frenchspacing		% Print only one space after terminal punctiation
\flushbottom		% Last line on every page is on the same height
\setlist[description]{style=sameline,leftmargin=0cm}

% Make sure type area is calculated correctly
\recalctypearea

% +--------------------+
% | Custom page styles |
% +--------------------+

%pagestyle for mainmatter
\newpairofpagestyles{ifs}{
	\automark[chapter]{chapter}
	\clearpairofpagestyles 			% clear header and footer
	\KOMAoptions{headsepline=true} 	% separating line for header
	\ihead{\headmark}				% chapter at inner header
	\ohead{\IfLanguageName{ngerman}{%
		\includegraphics[height=24pt,draft=false]{template/img/IFS_Logo_de.jpg}
	}{%
		\includegraphics[height=24pt,draft=false]{template/img/IFS_Logo_en.jpg}
		}%
	}
	\ofoot*{\pagemark} % pagemark at outer footer
	\addtokomafont{pagenumber}{\sffamily} % adapt font for page number
	\setkomafont{pagehead}{\normalfont\sffamily}  % set font for header
	}
  
% pagestyle for pages like abstract, list of abbreviations,...
\newpairofpagestyles{firstpages}{
  \cfoot*{\pagemark}
  \KOMAoptions{headsepline=false}
  }

% +-------------------------------------------------------+
% | Commands for creating essential pages of every thesis |
% +-------------------------------------------------------+

% Load the abstract (in both languages), the table of contents, the list of figures, the list of tables and the list of acronyms.
\newcommand{\preliminaries}{%
    \pagestyle{empty}
    \ifthenelse{\boolean{SBMT@titlepage}}{%
    	\includetitlepage
    }{}
    \frontmatter
    \pagestyle{firstpages}
    \ifthenelse{\boolean{SBMT@preamble}}{%
		\thesispreamble
    }{}
    \cleardoublepage
    \tableofcontents
    \acronymsandsymbols
    \listoffigures
    \listoftables
    \abstract
    \mainmatter
    \pagestyle{ifs}
}

% Adds the references stored in the file "references.bib"
\newcommand{\references}{%
    \bibliographystyle{plaindin}%
    \bibliography{references}%
}

% List of abbreviations and symbols
\newcommand{\loadacronyms}{%
    \input{mandatory/acronyms}%
}

\loadacronyms

\newcommand{\acronymsandsymbols}{%
	\chapter{\IfLanguageName{ngerman}{Abkürzungen und Formelzeichen}{Acronyms and symbols}}
  	\printacronyms
  	\newpage
  	\makeatletter
	\if@twoside%
   		%%% (twoside=true)
   		\cleardoublepage
   		
	\else%
   		%%% (twoside=false)
	\fi%  
	\makeatother
	\printglossary[title={Symbols}, style=symbunitlong]
}

% Abstract
\newcommand{\abstract}{%
    \cleardoublepage
    \chapter*{Kurzfassung}
    \addcontentsline{toc}{chapter}{Kurzfassung}
    \input{mandatory/abstract_de}
    \foreignlanguage{english}{%
    	\chapter*{Abstract}
    	\addcontentsline{toc}{chapter}{Abstract}
    	\input{mandatory/abstract_en}
		}
}

% Include titlepage (pdf)
\newcommand{\includetitlepage}
{
\includepdf[pages=-,fitpaper]{./mandatory/titlepage.pdf}
}

% Preamble
\newcommand{\thesispreamble}{%
	\makeatletter
	\if@twoside%
   		%%% (twoside=true)
   		\cleardoubleoddpage
   		
	\else%
   		%%% (twoside=false)
	\fi%  
  	\makeatother
    \chapter*{\IfLanguageName{ngerman}{Vorwort}{Acknowledgements}}
    \input{optional/preamble}
}

\newcommand{\mynewline}{\\[1ex]}
\newcommand{\fuelkey}[1]{\path|#1|}
\usepackage{refcount}   % provides \getpagerefnumber

\newcommand{\namevref}[1]{%
  \nameref{#1}%
  \ifnum\getpagerefnumber{#1}=\value{page}\relax
    % same page – omit the page reference
  \else
    \ on page~\pageref{#1}%
  \fi
}

\usepackage{ltablex} 
\keepXColumns 
\DeclareSIUnit{\fuel}{fuel}
\usepackage[gen]{eurosym}
\DeclareSIUnit{\EUR}{\text{\euro}}
\usepackage{bbm}

\usepackage{varioref}

\usepackage[section]{placeins}
\makeatletter
\AtBeginDocument{%
  \expandafter\renewcommand\expandafter\subsection\expandafter{%
    \expandafter\@fb@secFB\subsection
  }%
}
\makeatother

\raggedbottom

\hyphenation{Ka-ma-la-nath-shar-ma}

\DeclareSIUnit{\veh}{veh}
\DeclareSIUnit{\stops}{stops}
\DeclareSIUnit{\update}{update}
\DeclareSIUnit{\mile}{mi}
\DeclareSIUnit{\gallon}{gal}

\sloppy

\renewcommand{\vref}[1]{\ref{#1}}
\renewcommand{\namevref}[1]{\nameref{#1}}