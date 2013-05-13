Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2944B7CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 13:28:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B1F8AC004
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 11:28:49 -0700 (PDT)
Received: from mail-vb0-f48.google.com (mail-vb0-f48.google.com
	[209.85.212.48]) by cuda.sgi.com with ESMTP id MeaPcjuT0vFrdsmF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 13 May 2013 11:28:48 -0700 (PDT)
Received: by mail-vb0-f48.google.com with SMTP id q16so5446232vbe.35
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 11:28:47 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 13:28:47 -0500
Message-ID: <CAHBw7oSxcTYEEFzzhpZfH_EshyYXOsRBpf=S+bLEgCyQZkLFsA@mail.gmail.com>
Subject: xfs - high CPU usage when removing files
From: Radoslaw Garbacz <radoslaw.garbacz@xtremedatainc.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0959966147033403114=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0959966147033403114==
Content-Type: multipart/alternative; boundary=047d7bb04ce602301e04dc9db08e

--047d7bb04ce602301e04dc9db08e
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I noticed a high CPU usage when removing files from XFS partition on Linux,
CentOS (always close to 100%).
Is it a known issue, or is it more likely to be attributed to my testing
methodology ('time' command)?

Thanks in advance,

-- 
Best Regards,

Radoslaw Garbacz

--047d7bb04ce602301e04dc9db08e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Hi,<br><br></div>I noticed a high CPU usage when=
 removing files from XFS partition on Linux, CentOS (always close to 100%).=
<br></div>Is it a known issue, or is it more likely to be attributed to my =
testing methodology (&#39;time&#39; command)?<br>
<div><br></div><div>Thanks in advance,<br><br></div><div><div><div><div><di=
v>-- <br><div dir=3D"ltr"><div>Best Regards,<br><br>Radoslaw Garbacz<br></d=
iv></div>
</div></div></div></div></div></div>

--047d7bb04ce602301e04dc9db08e--


--===============0959966147033403114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0959966147033403114==--
