Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9Q7IHJG052110 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 02:18:17 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DAA511FA25D
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 00:35:02 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 7IToqqvtl7wqM0C4 for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 00:35:02 -0700 (PDT)
Date: Tue, 26 Oct 2010 09:19:21 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Best filesystems ?
Message-ID: <20101026091921.5ac8dc05@galadriel.home>
In-Reply-To: <AANLkTimA+67M9zJAo5CEDwzhrDYpK9Q_AqVEfNCwGTLn@mail.gmail.com>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
	<19646.55189.843933.481529@tree.ty.sabi.co.uk>
	<20101021020009.GG12506@dastard>
	<19648.27859.799400.168394@tree.ty.sabi.co.uk>
	<Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
	<19651.9652.631329.903552@tree.ty.sabi.co.uk>
	<20101023221639.5ac29ad9@galadriel.home>
	<AANLkTimA+67M9zJAo5CEDwzhrDYpK9Q_AqVEfNCwGTLn@mail.gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hank peng <pengxihan@gmail.com>
Cc: Linux XFS <xfs@oss.sgi.com>

Le Tue, 26 Oct 2010 08:55:49 +0800 vous =E9criviez:

> Which kernel version do you use? I occasionally found some errors like
> "Input/output error" after sudden power failure under linux kernel
> 2.6.23.

Various, still have a couple of machines running 2.6.17.13 (but in the
smaller range, 10 to 20 TB) and 2.6.22.19; many running 2.6.24.7, some
running 2.6.27.25, and the latest bunch is running 2.6.32.11. Never
used 2.6.23 in production so I couldn't tell much about this.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
