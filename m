Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49DQRCD226345 for <xfs@oss.sgi.com>; Sun, 9 May 2010 08:26:28 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E733B178856F
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 06:28:36 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id eCXiqKq69fo0A8Ff for
	<xfs@oss.sgi.com>; Sun, 09 May 2010 06:28:36 -0700 (PDT)
Date: Sun, 9 May 2010 15:28:18 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: failed to read root inode
Message-ID: <20100509152818.7481c1e1@galadriel.home>
In-Reply-To: <4BE5EB5D.5020702@hardwarefreak.com>
References: <4BE55A63.8070203@purplehaze.ch>
	<4BE5EB5D.5020702@hardwarefreak.com>
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

Le Sat, 08 May 2010 17:53:17 -0500 vous =E9criviez:

> Why did the "crash" of a single disk in a hardware RAID6 cause a
> kernel freeze?  What is your definition of "disk crash"?  A single
> physical disk failure should not have caused this under any
> circumstances.  The RAID card should have handled a single disk
> failure transparently.

The RAID array may go west if the disk isn't properly set up,
particularly if it's a desktop-class drive. =


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
