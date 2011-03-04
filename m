Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24IEdF1181250 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 12:14:39 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7C53A85E61
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 10:17:26 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id aHnMFzAGEFfeb68X for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 10:17:26 -0800 (PST)
Date: Fri, 4 Mar 2011 19:17:29 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: corruption, xfs_repair 3.1.4 segfaults, xfs_repair 2.9.8 works
Message-ID: <20110304191729.541f09a0@harpe.intellique.com>
In-Reply-To: <20110304173021.GA7912@schmorp.de>
References: <20110304121407.065d9f17@harpe.intellique.com>
	<20110304173021.GA7912@schmorp.de>
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

Le Fri, 4 Mar 2011 18:30:22 +0100
Marc Lehmann <schmorp@schmorp.de> =E9crivait:

> http://ue.tst.eu/f3860347ab2147d87fdf8f961d6d4358.txt
> =

> afterwards, I had the contents of the single directory that caused
> issues in lost+found, and no unreadable directories left.

Quite expected, given the corrupted directory.
 =

> So definitely a regression in 3.1.4.

Yes. I'll keep a 2.9.x xfs_repair at hand for a while I guess :)

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
