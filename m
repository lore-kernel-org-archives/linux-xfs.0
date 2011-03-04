Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24BBLfk158502 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 05:11:22 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26B811AF28B5
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 03:14:11 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 4iraF8nADH8MbEXC for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 03:14:11 -0800 (PST)
Date: Fri, 4 Mar 2011 12:14:07 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: corruption, xfs_repair 3.1.4 segfaults
Message-ID: <20110304121407.065d9f17@harpe.intellique.com>
In-Reply-To: <20110304102939.GA10416@schmorp.de>
References: <20110302175818.GA8290@schmorp.de>
	<20110302224329.3f62c172@galadriel2.home>
	<20110304071123.GC2316@schmorp.de>
	<20110304085146.368046e7@galadriel2.home>
	<20110304102939.GA10416@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

Le Fri, 4 Mar 2011 11:29:39 +0100
Marc Lehmann <schmorp@schmorp.de> =E9crivait:

> I think that, no matter what the loop device would do, xfs_repair is
> buggy
> - it simply shouldn't crash, no matter how corrupted the filesystem
> is.
> =


That's true. After you've copied everything, you could try using
Lenny's xfs_repair (v 2.9.x IIRC). Just in case, it may do better.

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
