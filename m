Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNLkfxU256535 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 15:46:41 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A28A621CB8D
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:48:38 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id gi33l2AmBxyETspj for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:48:38 -0800 (PST)
Date: Thu, 23 Dec 2010 22:48:32 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101223224832.1abb3cb8@galadriel.home>
In-Reply-To: <4D13A8E6.7090606@hardwarefreak.com>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
	<20101223195544.53d45f0b@galadriel.home>
	<alpine.DEB.2.00.1012231403440.5924@p34.internal.lan>
	<4D13A8E6.7090606@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Le Thu, 23 Dec 2010 13:54:14 -0600 vous =E9criviez:

> Best guess?  Those 3TB Hitachi drives use 512 byte translated native
> 4KB sectors. =


Yes, I'm sure that no new drive model comes with true 512B sectors
anymore...

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
