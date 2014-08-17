Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D11CE7F47
	for <xfs@oss.sgi.com>; Sat, 16 Aug 2014 21:06:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF7268F8033
	for <xfs@oss.sgi.com>; Sat, 16 Aug 2014 19:06:11 -0700 (PDT)
Received: from BLU004-OMC4S29.hotmail.com (blu004-omc4s29.hotmail.com
	[65.55.111.168]) by cuda.sgi.com with ESMTP id au8XEGsNuF2EfuC3
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Aug 2014 19:06:06 -0700 (PDT)
Message-ID: <BLU181-W306A7E4DE2F035EA4530139CD70@phx.gbl>
From: Prithvi Rathore <prithvi_rathore@outlook.com>
Subject: Help setting up XFS
Date: Sun, 17 Aug 2014 07:36:06 +0530
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3971379387204660161=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3971379387204660161==
Content-Type: multipart/alternative;
	boundary="_cc8907e2-2e31-4777-be6f-9f00e35dd3e4_"

--_cc8907e2-2e31-4777-be6f-9f00e35dd3e4_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi=2C    I am a student currently pursuing my under-graduation and would lo=
ve to use XFS. I believe it has a lot to offer and I Iook forwarding to tes=
ting and using it on an external device like a pen-drive (USB) for starters=
.    I was a bit confused on how to set up XFS. I am currently using Ubuntu=
 14.04 dual boot (via rEFInd) with Mac OS X on MacBook Air 2013.     The va=
rious documentation available at xfs.org=2C surely is very informative and =
provides an elaborate description on XFS features. Setting XFS up however i=
s where i am a bit stuck. From the various online material available=2C I f=
ound the following ways:
1) From terminal     # sudo apt-get install xfsprogs      # sudo apt-get in=
stall xfsdump    I believe it sets up the version 3.1.9.
2) Another method was=2C that i tried was downloading the tar file from the=
 sgi link. It downloaded xfs-progs-       3.2.1.tar.gz  =20
3) From various discussions done online i found people changing a few setti=
ngs in the $ make menuconfig GUI     screen=2C hence adding support for XFS=
.
   I am also a bit confused on how to use the device name (USB pen drive) w=
hen i will run the mkfs.xfs as I heard it doesn't work for a mounted device=
.  I know you may be busy and my mail might seem a bit amateur=2C but I wou=
ld really appreciate if you could guide me on how to setup XFS and run it f=
or a USB device. Any link explaining the same would also be really apprecia=
ted. Thank you.
Warm Regards 		 	   		  =

--_cc8907e2-2e31-4777-be6f-9f00e35dd3e4_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'><div>Hi=2C</div><div>&nbsp=3B &n=
bsp=3B I am a student currently pursuing my under-graduation and would love=
 to use XFS. I believe it has a lot to offer and I Iook forwarding to testi=
ng and using it on an external device like a pen-drive (USB) for starters.<=
/div><div>&nbsp=3B &nbsp=3B I was a bit confused on how to set up XFS. I am=
 currently using Ubuntu 14.04 dual boot (via rEFInd) with Mac OS X on MacBo=
ok Air 2013.&nbsp=3B</div><div>&nbsp=3B &nbsp=3B The various documentation =
available at xfs.org=2C surely is very informative and provides an elaborat=
e description on XFS features. Setting XFS up however is where i am a bit s=
tuck. From the various online material available=2C I found the following w=
ays:</div><div><br></div><div>1) From terminal</div><div>&nbsp=3B &nbsp=3B =
&nbsp=3B# sudo apt-get install xfsprogs&nbsp=3B</div><div>&nbsp=3B &nbsp=3B=
 &nbsp=3B# sudo apt-get install xfsdump</div><div>&nbsp=3B &nbsp=3B I belie=
ve it sets up the version 3.1.9.</div><div><br></div><div>2) Another method=
 was=2C that i tried was downloading the tar file from the sgi link. It dow=
nloaded xfs-progs- &nbsp=3B&nbsp=3B</div><div>&nbsp=3B &nbsp=3B 3.2.1.tar.g=
z &nbsp=3B&nbsp=3B</div><div><br></div><div>3) From various discussions don=
e online i found people changing a few settings in the $ make menuconfig GU=
I&nbsp=3B</div><div>&nbsp=3B &nbsp=3B screen=2C hence adding support for XF=
S.</div><div><br></div><div>&nbsp=3B &nbsp=3BI am also a bit confused on ho=
w to use the device name (USB pen drive) when i will run the mkfs.xfs as I =
heard it doesn't work for a mounted device.</div><div>&nbsp=3B I know you m=
ay be busy and my mail might seem a bit amateur=2C but I would really appre=
ciate if you could guide me on how to setup XFS and run it for a USB device=
. Any link explaining the same would also be really appreciated. Thank you.=
</div><div><br></div><div>Warm Regards</div> 		 	   		  </div></body>
</html>=

--_cc8907e2-2e31-4777-be6f-9f00e35dd3e4_--


--===============3971379387204660161==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3971379387204660161==--
