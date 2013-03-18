Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C86F7F6D
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 19:33:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9CFB1AC001
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 17:33:07 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id DbY0c4LTcGxxYDwS (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Mar 2013 17:33:06 -0700 (PDT)
Subject: Bug#695640: xfs_quota: cannot find mount point for path: Success
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.695640.B695640.13635666435279@bugs.debian.org>
MIME-Version: 1.0
In-Reply-To: <CAA0ZO6BvLQGt_9G-FSi+ZMCzJh_kmb1z2bdoPPwaVMVVK1UXJw@mail.gmail.com>
References: <CAA0ZO6CtLRkgrpXqapg3B5oMwGdLq8tS3y4dYG47aYX5BZkA=g@mail.gmail.com>
	<20121211221419.GZ27055@sgi.com>
	<CAA0ZO6APzwQCX=yf=qq8NkmjwDHVsgRBNCgN3KNW3RLgAWB=8A@mail.gmail.com>
	<20121211223700.GA27055@sgi.com>
	<CAA0ZO6BOUXTMpdrR-r=__-ZaAM6X39h2SisYXLfTTraTcttr+g@mail.gmail.com>
	<20121211231533.GG16353@dastard>
	<CAA0ZO6BvLQGt_9G-FSi+ZMCzJh_kmb1z2bdoPPwaVMVVK1UXJw@mail.gmail.com>
Date: Mon, 18 Mar 2013 11:30:35 +1100
Message-ID: <CAA0ZO6BGqvBdXRr9U4BagQYGa=_kC2VUgtOj+qPB5HEX2U8O7w@mail.gmail.com>
From: Brian May <brian@microcomaustralia.com.au>
Reply-To: Brian May <brian@microcomaustralia.com.au>, 695640@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9040443541048053448=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: 695640@bugs.debian.org, Ben Myers <bpm@sgi.com>

--===============9040443541048053448==
Content-Type: multipart/alternative; boundary=f46d04446a4bf35ec504d82818c4

--f46d04446a4bf35ec504d82818c4
Content-Type: text/plain; charset=UTF-8

On 12 December 2012 10:20, Brian May <brian@microcomaustralia.com.au> wrote:

> On 12 December 2012 10:15, Dave Chinner <david@fromorbit.com> wrote:
>
>> Full strace output, please.
>
>
> Attached.
>

Did my strace output help diagnose this bug?

Thanks
-- 
Brian May <brian@microcomaustralia.com.au>

--f46d04446a4bf35ec504d82818c4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On 12 December 2012 10:20, Brian May <span dir=3D"ltr">&lt;<a href=
=3D"mailto:brian@microcomaustralia.com.au" target=3D"_blank">brian@microcom=
australia.com.au</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"gmail_extra">On 12 December 20=
12 10:15, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromor=
bit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br>
<div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Full strace output, please.</blockquote></div><br>Attached.</div></blockquo=
te><div><br></div><div style>Did my strace output help diagnose this bug?</=
div><div style><br></div><div style>Thanks=C2=A0</div></div>-- <br>Brian Ma=
y &lt;<a href=3D"mailto:brian@microcomaustralia.com.au" target=3D"_blank">b=
rian@microcomaustralia.com.au</a>&gt;
</div></div>

--f46d04446a4bf35ec504d82818c4--


--===============9040443541048053448==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9040443541048053448==--
