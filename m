Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN19E6f062319 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:09:14 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B36014784EB
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 17:11:10 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id EijFO1UckK55bdMV for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 17:11:10 -0800 (PST)
Date: Thu, 23 Dec 2010 02:10:59 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101223021059.059fa9db@galadriel.home>
In-Reply-To: <alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Le Wed, 22 Dec 2010 19:28:29 -0500 (EST) vous =E9criviez:

> Hi, I concur, for hardware raid (at least on 3ware cards) I have
> found it makes no difference, thanks for confirming.
> =

> Which RAID cards did you use?

Mostly 3Ware until recently, but I switched to Adaptec. However I'm
still running tests to sort out any peculiarity - found quite a lot of
"features" since 2008 :)

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
