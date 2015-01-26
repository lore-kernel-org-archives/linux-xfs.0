Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7B907FCC
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 03:08:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A9663304043
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 01:08:03 -0800 (PST)
Received: from exchange01.SOBEY.COM ([61.139.78.4]) by cuda.sgi.com with ESMTP
	id cWO9rqQBrVoxnyUE (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 01:07:59 -0800 (PST)
Date: Mon, 26 Jan 2015 17:07:37 +0800
From: "lihongliang@sobey.com" <lihongliang@sobey.com>
Subject: I think that get direct directory size int the xfs file system
MIME-Version: 1.0
Message-ID: <201501261707321631278@sobey.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2455807887705805592=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>

--===============2455807887705805592==
Content-Type: multipart/alternative;
	boundary="----=_001_NextPart588647845785_=----"

------=_001_NextPart588647845785_=----
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: base64

SGVsbG8NCiAgICAgICAgQ2FuIGdldCBkaXJlY3QgZGlyZWN0b3J5IHNpemUgaW50IHRoZSBYRlMg
ZmlsZSBzeXN0ZW0/DQpleGFtcGxlo7oNCiByb290QGZpY3NOb2RlMSB0ZXN0MV0jIG1vdW50IHwg
Z3JlcCB4ZnMgDQovZGV2L3NkYyBvbiAveGZzIHR5cGUgeGZzIChydyx1cXVvdGEpIA0KW3Jvb3RA
Zmljc05vZGUxIHRlc3QxXSMgcHdkIA0KL3hmcy90ZXN0MSANCltyb290QGZpY3NOb2RlMSB0ZXN0
MV0jIGxzIC1saCANCnRvdGFsIDVNIA0KLXJ3LXItLXItLSAxIHJvb3Qgcm9vdCAxLjBNIEphbiAy
NiAwOTozMyBibG9jazEgDQotcnctci0tci0tIDEgcm9vdCByb290IDEuME0gSmFuIDI2IDA5OjMz
IGJsb2NrMiANCi1ydy1yLS1yLS0gMSByb290IHJvb3QgMS4wTSBKYW4gMjYgMDk6MzMgYmxvY2sz
IA0KLXJ3LXItLXItLSAxIHJvb3Qgcm9vdCAxLjBNIEphbiAyNiAwOTozMyBibG9jazQgDQotcnct
ci0tci0tIDEgcm9vdCByb290IDEuME0gSmFuIDI2IDA5OjMzIGJsb2NrNSANCltyb290QGZpY3NO
b2RlMSB0ZXN0MV0jICANCg0KICAgY2FuIEkgZ2V0IGRpcmVjdCBpdCAgYnkgY2FsbCBzeXN0ZW0g
ZnVuY3Rpb24gdGhlIHRoYXQgdGhlIC94ZnMvdGVzdDEgaXMgNU0/DQoNCg0KbGlob25nbGlhbmdA
c29iZXkuY29tDQo=

------=_001_NextPart588647845785_=----
Content-Type: text/html; charset="GB2312"
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charse=
t=3DGB2312"><style>body { line-height: 1.5; }body { font-size: 10.5pt; fon=
t-family: =CE=A2=C8=ED=D1=C5=BA=DA; color: rgb(0, 0, 0); line-height: 1.5;=
 }</style></head><body>=0A<div><span></span>Hello</div><div><span style=3D=
"background-color: rgba(0, 0, 0, 0);">&nbsp; &nbsp;&nbsp;</span><span styl=
e=3D"background-color: rgba(0, 0, 0, 0); font-size: 10.5pt; line-height: 1=
.5;">&nbsp; &nbsp; C</span><span style=3D"background-color: rgba(0, 0, 0, =
0); font-size: 10.5pt; line-height: 1.5;">an get direct directory size int=
 the XFS file system?</span></div><div>example=A3=BA</div><div><span style=
=3D"background-color: rgba(0, 0, 0, 0); font-size: 10.5pt; line-height: 1.=
5;">&nbsp;</span><span style=3D"background-color: rgba(0, 0, 0, 0); font-s=
ize: 10.5pt; line-height: 1.5;">root@ficsNode1 test1]# mount | grep xfs&nb=
sp;</span></div><span style=3D"background-color: rgba(0, 0, 0, 0);">/dev/s=
dc on /xfs type xfs (rw,uquota)=0A<br>[root@ficsNode1 test1]# pwd =0A<br>/=
xfs/test1=0A<br>[root@ficsNode1 test1]# ls -lh=0A<br>total 5M=0A<br>-rw-r-=
-r-- 1 root root 1.0M Jan 26 09:33 block1=0A<br>-rw-r--r-- 1 root root 1.0=
M Jan 26 09:33 block2=0A<br>-rw-r--r-- 1 root root 1.0M Jan 26 09:33 block=
3=0A<br>-rw-r--r-- 1 root root 1.0M Jan 26 09:33 block4=0A<br>-rw-r--r-- 1=
 root root 1.0M Jan 26 09:33 block5=0A<br>[root@ficsNode1 test1]#&nbsp;</s=
pan>=0A<div><br></div><div>&nbsp; &nbsp;can I get direct it &nbsp;by call =
system function the that the<b> /xfs/test1</b> is 5M?</div><hr style=3D"wi=
dth: 210px; height: 1px;" color=3D"#b5c4df" size=3D"1" align=3D"left">=0A<=
div><span><div style=3D"MARGIN: 10px; FONT-FAMILY: verdana; FONT-SIZE: 10p=
t"><div>lihongliang@sobey.com</div></div></span></div>=0A</body></html>
------=_001_NextPart588647845785_=------


--===============2455807887705805592==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2455807887705805592==--
