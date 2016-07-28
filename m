Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24F357CA3
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 22:30:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9D0FAC003
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 20:30:27 -0700 (PDT)
Received: from AUS01-SY3-obe.outbound.protection.outlook.com
	(mail-sy3aus01on0073.outbound.protection.outlook.com
	[104.47.117.73]) by cuda.sgi.com with ESMTP id R9WzEB4zYe6iqx3s
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2016 20:30:23 -0700 (PDT)
From: Ryan Lindsay <rlindsay@unimelb.edu.au>
Subject: Any better way to interact with xfs?
Date: Thu, 28 Jul 2016 03:30:16 +0000
Message-ID: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
Content-Language: en-AU
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0135228715467137022=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0135228715467137022==
Content-Language: en-AU
Content-Type: multipart/alternative;
	boundary="_000_SYXPR01MB044863A851C967C37649BE3FF8000SYXPR01MB0448ausp_"

--_000_SYXPR01MB044863A851C967C37649BE3FF8000SYXPR01MB0448ausp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi

I have a bit of a specific requirement.

I have a server that currently has a 12T worth of data on it on an xfs form=
atted LV.

currently the file permissions are set via an LDAP, however we are having t=
o move to AD for out authentication mechanism. Which will change the value =
of the existing UID's and GID's

Since XFS has a lot of mechanisms that allow things to happen in parallel. =
I was wondering if there was a way of interacting at the file system level =
to facilitate a change of UID's on files rather than having to just chown r=
ecursively down the file system. The faster I can update the permissions th=
e better basically


Ryan Lindsay | Research Infrastructure Lead

Faculty of Science IT
Room G09, Old Geology Bld, University of Melbourne, 3010, VIC
Telephone +61 3 83446255 | Mobile +61 0407537949 | Email rlindsay@unimelb.e=
du.au

This email and any attachments may contain personal information or informat=
ion that is otherwise confidential or the subject of copyright. Any use, di=
sclosure or copying of any part of it is prohibited. The University does no=
t warrant that this email or any attachments are free from viruses or defec=
ts. Please check any attachments for viruses and defects before opening the=
m. If this email is received in error please delete it and notify us by ret=
urn email.

--_000_SYXPR01MB044863A851C967C37649BE3FF8000SYXPR01MB0448ausp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;back=
ground-color:#FFFFFF;font-family:Calibri,Arial,Helvetica,sans-serif;">
<p>Hi</p>
<p>I have a bit of a specific requirement.&nbsp;</p>
<p>I have a server that currently has a 12T worth of data on it on an xfs f=
ormatted LV.</p>
<p>currently the file permissions are set via an LDAP, however we are havin=
g to move to AD for out authentication mechanism. Which will change the val=
ue of the existing UID's and GID's</p>
<p>Since XFS has a lot of mechanisms that allow things to happen in paralle=
l. I was wondering if there was a way of interacting at the file system lev=
el to facilitate a change of UID's on files rather than having to just chow=
n recursively down the file system.
 The faster I can update the permissions the better basically&nbsp;&nbsp;</=
p>
<p><br>
</p>
<div id=3D"Signature">
<div style=3D"font-family:Tahoma; font-size:13px">
<div style=3D"font-family:Tahoma; font-size:13px">
<div style=3D"font-family:Tahoma; font-size:13px">
<p style=3D"margin-bottom:0.5cm; line-height:100%"><font color=3D"#0000ff">=
<font face=3D"Tahoma"><font size=3D"2" style=3D"font-size:9pt"><font face=
=3D"Arial, sans-serif"><font size=3D"2" style=3D"font-size:9pt"><b>Ryan Lin=
dsay</b></font></font> |
<font face=3D"Arial"><font size=3D"2" style=3D"font-size:10pt"><b>Research =
Infrastructure Lead</b></font></font><font face=3D"Arial"><font size=3D"2" =
style=3D"font-size:10pt">
</font></font></font></font></font></p>
<p style=3D"margin-bottom:0cm; font-variant:normal; letter-spacing:normal; =
font-style:normal; font-weight:normal">
<font color=3D"#000000"><font face=3D"Times New Roman, serif"><font size=3D=
"3" style=3D"font-size:12pt"><font color=3D"#0000ff"><font face=3D"Arial, s=
ans-serif"><font size=3D"2" style=3D"font-size:9pt">Faculty of Science IT<b=
r>
Room G09, Old Geology Bld, University of Melbourne, 3010, VIC</font></font>=
</font><font color=3D"#1f497d"><font face=3D"Arial, sans-serif"><font size=
=3D"2" style=3D"font-size:9pt"><br>
</font></font></font><font color=3D"#1f497d"><font face=3D"Arial, sans-seri=
f"><font size=3D"2" style=3D"font-size:9pt"><b>Telephone</b></font></font><=
/font><font color=3D"#1f497d"><font face=3D"Arial, sans-serif"><font size=
=3D"2" style=3D"font-size:9pt">&nbsp;</font></font></font><font face=3D"Ari=
al, sans-serif"><font size=3D"2" style=3D"font-size:9pt">&#43;61
 3 83446255</font></font><font color=3D"#1f497d"><font face=3D"Arial, sans-=
serif"><font size=3D"2" style=3D"font-size:9pt"> |&nbsp;</font></font></fon=
t><font color=3D"#1f497d"><font face=3D"Arial, sans-serif"><font size=3D"2"=
 style=3D"font-size:9pt"><b>Mobile</b></font></font></font><font color=3D"#=
1f497d"><font face=3D"Arial, sans-serif"><font size=3D"2" style=3D"font-siz=
e:9pt">&nbsp;</font></font></font><font face=3D"Arial, sans-serif"><font si=
ze=3D"2" style=3D"font-size:9pt">&#43;61
 0407537949</font></font><font color=3D"#1f497d"><font face=3D"Arial, sans-=
serif"><font size=3D"2" style=3D"font-size:9pt"> |&nbsp;</font></font></fon=
t><font color=3D"#1f497d"><font face=3D"Arial, sans-serif"><font size=3D"2"=
 style=3D"font-size:9pt"><b>Email</b></font></font></font><font color=3D"#1=
f497d"><font face=3D"Arial, sans-serif"><font size=3D"2" style=3D"font-size=
:9pt">
</font></font></font><font face=3D"Arial, sans-serif"><font size=3D"2" styl=
e=3D"font-size:9pt">rlindsay@unimelb.edu.au</font></font><font color=3D"#1f=
497d">&nbsp;
</font></font></font></font></p>
<p style=3D"margin-bottom:0cm; font-variant:normal; letter-spacing:normal; =
font-style:normal; font-weight:normal">
<font color=3D"#1f497d"><font face=3D"Arial, sans-serif"><font size=3D"1" s=
tyle=3D"font-size:7pt">This email and any attachments may contain personal =
information or information that is otherwise confidential or the subject of=
 copyright. Any use, disclosure or copying
 of any part of it is prohibited. The University does not warrant that this=
 email or any attachments are free from viruses or defects. Please check an=
y attachments for viruses and defects before opening them. If this email is=
 received in error please delete
 it and notify us by return email.</font></font></font></p>
</div>
</div>
</div>
</div>
</div>
</body>
</html>

--_000_SYXPR01MB044863A851C967C37649BE3FF8000SYXPR01MB0448ausp_--


--===============0135228715467137022==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0135228715467137022==--
