Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8C8gowG257085 for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 03:42:50 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B31571BD98B2
	for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 01:43:35 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id dHUPAlWiYui9iGfF for
	<xfs@oss.sgi.com>; Sun, 12 Sep 2010 01:43:35 -0700 (PDT)
Date: Sun, 12 Sep 2010 10:43:21 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS defragmentation issue
Message-ID: <20100912104321.5529f74c@galadriel.home>
In-Reply-To: <4C8BDAC8.8010203@hardwarefreak.com>
References: <4C8A4395.5070702@kickstone.com> <4C8B27E4.2050102@kickstone.com>
	<20100911082330.GG705@dastard> <4C8BDAC8.8010203@hardwarefreak.com>
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

Le Sat, 11 Sep 2010 14:38:48 -0500 vous =E9criviez:

> That's good to know Dave.  Thanks.  I created a short-name script a
> while back with "echo 3 > /proc/sys/vm/drop_caches" merely so I could
> "clear the baffles" now and then. =


But isn't it somewhat risky? isn't there any risk of data loss by
dropping cache at any moment?

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
