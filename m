Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNC1SYt162553 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 06:01:28 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DD03147AEF6
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 04:03:24 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id t7HClqhBJbZoRnzx for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 04:03:24 -0800 (PST)
Date: Thu, 23 Dec 2010 13:03:22 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101223130322.28644309@harpe.intellique.com>
In-Reply-To: <alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
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

Le Thu, 23 Dec 2010 04:43:26 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> =E9crivait:

> So for an 18 disk raid-6 with 256k stripe you would recommend:
> =

> mkfs.xfs with su=3D256k,sw=3D16 for optimal performance with inode64
> mount option?
> =


Yes that should be the best setting. =


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
