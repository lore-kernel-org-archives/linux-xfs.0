Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n98FEuXI014932 for <xfs@oss.sgi.com>; Thu, 8 Oct 2009 10:14:57 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0E2B6BE962E
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2009 08:16:22 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id vL6IPJPwBuQp7QuM for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2009 08:16:22 -0700 (PDT)
Date: Thu, 08 Oct 2009 17:16:19 +0200
From: "Klaus Liebhard" <Magenbrot@gmx.de>
Message-ID: <20091008151619.77730@gmx.net>
MIME-Version: 1.0
Subject: Some questions about file system development...
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6315021144712576538=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6315021144712576538==
Content-Type: multipart/alternative;
 boundary="========GMXBoundary77731255014979762814"

--========GMXBoundary77731255014979762814
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi all,                 I'm a student here in Germany and my Prof. wants 
me to do a brief presentation about developing file systems and managing 
file system development.        I searched across the internet, but 
information about that is really hard to find.                 So I put 
some questions together. If you don't mind I'd like to ask you if you could 
answer them briefly.        Also if you have other sources where I can find 
information about that are appreciated.                 Thanks, Klaus      
                    Here are my questions:                 1. How much 
time (overall) is needed to develop a file system like XFS from scratch?    
    2. How many people are currently developing XFS in full time or part 
time?        3. Have you developed a theroetical concept or was it more 
trial and error?        4. If yes how much time did you spend on developing 
a concept?        5. Have you (or others) been experienced in file system 
development when you started this project?        6. Do you think there has 
to be at least one experienced developer to develop a file system like XFS? 
       7. How does the effort split up (concept, developing, testing)?      
  8. What is the most problematic part of developing file systems?        
9. Did you get help from other file system developers (which maintain their 
own file system)?        10. Are there people from "outside" and ask for 
features?        11. If yes dou you take them into consideration?        
12. What's the most complex feature of your file system?    
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01

--========GMXBoundary77731255014979762814
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html>
    <head>
        <title></title>
        <style type=3D"text/css" media=3D"screen">
BODY {
	PADDING-RIGHT: 5px; PADDING-LEFT: 5px; FONT-SIZE: 12px; PADDING-BOTTOM: 5p=
x; MARGIN: 0px; PADDING-TOP: 5px; FONT-FAMILY: verdana, arial, helvetica, s=
ans-serif; BACKGROUND-COLOR: #fff
}
P {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px
}
UL {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px
}
LI {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px
}
BLOCKQUOTE {
	MARGIN-LEFT: 5px
}
DIV.signature {
	FONT-SIZE: 0.9em; COLOR: #666; FONT-FAMILY: monospace
}</style>
    </head>
    <body>
        <div dir=3D"ltr"><font face=3D"Tahoma" color=3D"#000000" size=3D"2"=
>Hi all,</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">&nbsp;</font></di=
v>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">I'm a student her=
e in Germany and my Prof. wants me to do a brief presentation about develop=
ing file systems and managing file system development.</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">I searched across=
 the internet, but information about that is really hard to find.</font></d=
iv>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">&nbsp;</font></di=
v>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">So I put some que=
stions together. If you don't mind I'd like to ask you if you could answer =
them briefly.</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">Also if you have =
other sources where I can find information about that are appreciated.</fon=
t></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">&nbsp;</font></di=
v>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">Thanks, Klaus</fo=
nt></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">&nbsp;</font></di=
v>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">&nbsp;</font></di=
v>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">Here are my quest=
ions:</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">&nbsp;</font></di=
v>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">1. How much time =
(overall) is needed to develop a file system like XFS from scratch?</font><=
/div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">2. How many peopl=
e are currently developing&nbsp;XFS in full time or part time?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">3. Have you devel=
oped a theroetical concept or was it more trial and error?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">4. If yes how muc=
h time did you spend on developing a concept?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">5.&nbsp;Have you =
(or others) been experienced in file system development when you started th=
is project?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">6. Do you think t=
here has to be at least one experienced developer to develop a file system =
like XFS?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">7. How does the e=
ffort split up (concept, developing, testing)?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">8. What is the mo=
st problematic part of developing file systems?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">9. Did you get he=
lp from other file system developers (which maintain their own file system)=
?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">10. Are there peo=
ple from &quot;outside&quot; and ask for features?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">11. If yes dou yo=
u take them into consideration?</font></div>
        <div dir=3D"ltr"><font face=3D"Tahoma" size=3D"2">12. What's the mo=
st complex feature of your file system?</font></div>
    <div class=3D"signature"><br /><br /><br />-- <br />GRATIS f=C3=BCr all=
e GMX-Mitglieder: Die maxdome Movie-FLAT!<br />Jetzt freischalten unter htt=
p://portal.gmx.net/de/go/maxdome01</div></body>
</html>

--========GMXBoundary77731255014979762814--


--===============6315021144712576538==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6315021144712576538==--
