Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2A4E7CBF
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 18:31:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2C82304048
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 16:31:49 -0700 (PDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
	[209.85.215.42]) by cuda.sgi.com with ESMTP id Tpco8oAgM0uuffX9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Mar 2013 16:31:18 -0700 (PDT)
Received: by mail-la0-f42.google.com with SMTP id fe20so2044976lab.29
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 16:31:16 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Mar 2013 23:31:16 +0000
Message-ID: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
Subject: Crash with 3.8.3 and TuxOnIce
From: Pedro Ribeiro <pedrib@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4622438545597234389=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4622438545597234389==
Content-Type: multipart/alternative; boundary=f46d04426b667fbb3404d84f80b5

--f46d04426b667fbb3404d84f80b5
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I'm using a TuxOnIce enabled kernel, and recently moved from 3.7.1 to
3.8.3. The former used to work nicely, but now I get a hard crash when I
try to hibernate.
This is solely related to TuxOnIce as it does not happen in the default
hibernation.

I know this is an unsupported out of tree patch, but can you please help me
debug it or point in the right direction?

Unfortunately as this was a kernel crash all I have are crappy photos, but
they do show a readable stack trace:
img18[dot]imageshack[dot]us/img18/395/imag0228hp[dot]jpg
img13[dot]imageshack[dot]us/img13/4375/imag0231p[dot]jpg

(I removed the HTTP part and the dots off the links else it would bounce
back from the list)

Thanks in advance for your help.

Regards,
Pedro

--f46d04426b667fbb3404d84f80b5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-family:arial,sans-serif;font-size:13px=
">Hi,</span><div style=3D"font-family:arial,sans-serif;font-size:13px"><br>=
</div><div style=3D"font-family:arial,sans-serif;font-size:13px">I&#39;m us=
ing a TuxOnIce enabled kernel, and recently moved from 3.7.1 to 3.8.3. The =
former used to work nicely, but now I get a hard crash when I try to hibern=
ate.=A0</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px">This is solely r=
elated to TuxOnIce as it does not happen in the default hibernation.</div><=
div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div st=
yle=3D"font-family:arial,sans-serif;font-size:13px">
I know this is an unsupported out of tree patch, but can you please help me=
 debug it or point in the right direction?</div><div style=3D"font-family:a=
rial,sans-serif;font-size:13px"><br></div><div style=3D"font-family:arial,s=
ans-serif;font-size:13px">
Unfortunately as this was a kernel crash all I have are crappy photos, but =
they do show a readable stack trace:</div><div style=3D"font-family:arial,s=
ans-serif;font-size:13px">img18[dot]imageshack[dot]us/img18/395/imag0228hp[=
dot]jpg</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px">img13[dot]images=
hack[dot]us/img13/4375/imag0231p[dot]jpg<br></div><div style=3D"font-family=
:arial,sans-serif;font-size:13px"><br></div><div style=3D"font-family:arial=
,sans-serif;font-size:13px">
(I removed the HTTP part and the dots off the links else it would bounce ba=
ck from the list)</div><div style=3D"font-family:arial,sans-serif;font-size=
:13px"><br></div><div style=3D"font-family:arial,sans-serif;font-size:13px"=
>
Thanks in advance for your help.</div><div style=3D"font-family:arial,sans-=
serif;font-size:13px"><br></div><div style=3D"font-family:arial,sans-serif;=
font-size:13px">Regards,</div><div style=3D"font-family:arial,sans-serif;fo=
nt-size:13px">
Pedro</div></div>

--f46d04426b667fbb3404d84f80b5--


--===============4622438545597234389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4622438545597234389==--
