Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8IBFcxV121113 for <xfs@oss.sgi.com>; Sat, 18 Sep 2010 06:15:39 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BA24828AB
	for <xfs@oss.sgi.com>; Sat, 18 Sep 2010 04:16:28 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id IGNKvEJKEnRqqLpA for
	<xfs@oss.sgi.com>; Sat, 18 Sep 2010 04:16:28 -0700 (PDT)
Date: Sat, 18 Sep 2010 13:16:14 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LWN.net article: creating 1 billion files -> Tests we did
Message-ID: <20100918131614.1e724833@galadriel.home>
In-Reply-To: <4C9291C3.7000709@hardwarefreak.com>
References: <201008191312.49346@zmi.at>
	<20100916121350.3ab30ca5@harpe.intellique.com>
	<4C9291C3.7000709@hardwarefreak.com>
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

Le Thu, 16 Sep 2010 16:53:07 -0500 vous =E9criviez:

> This is a test of storage system performance, and you left out the
> storage array specs?  By doing so it seems you're stating the
> underlying storage is not relevant to the results.

Sorry :) The storage is a 24 2TB disks RAID-6 array on a 3W&re 9650. Not
exactly stellar at IOPS performance.

> So, are you saying I should be able to duplicate your results with
> that dual Opty system, but using an md RAID0 stripe over 8x2TB SATA
> disks connected to two $60 4 port SiI 3124 PCIe x1 cards?
> =


Your setup may be slightly slower.

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
