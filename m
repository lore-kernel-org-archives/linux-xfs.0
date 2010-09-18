Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8IBcnZN121746 for <xfs@oss.sgi.com>; Sat, 18 Sep 2010 06:38:49 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F8E98268D
	for <xfs@oss.sgi.com>; Sat, 18 Sep 2010 04:39:38 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id al9yE9ZOjAfC92WS for
	<xfs@oss.sgi.com>; Sat, 18 Sep 2010 04:39:38 -0700 (PDT)
Date: Sat, 18 Sep 2010 13:39:24 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LWN.net article: creating 1 billion files -> Tests we did
Message-ID: <20100918133924.256cab8a@galadriel.home>
In-Reply-To: <19603.51260.32944.928119@tree.ty.sabi.co.uk>
References: <201008191312.49346@zmi.at>
	<20100916121350.3ab30ca5@harpe.intellique.com>
	<19603.51260.32944.928119@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg@xfs2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

Le Fri, 17 Sep 2010 20:57:48 +0100 vous =E9criviez:

> LWN is usually fairly decent, but I have noticed it does
> occasionally waste pixels on/bits things that the author(s)
> misrepresent as storage or file system tests.

How unfortunate we missed your precious stance on that matter. Everybody
knows that benchmarks are mostly useless /per se/, however it often
occurs that comparative benchmarks may easily reveal some interesting
differences.

As for the interest of an experiment of pushing something to the limit
for the sake of it, it may equally reveal interesting bugs. The fact
that all filesystems in this tests didn't simply *fail* under the load
is by itself revealing of the overall robustness and stability of
these, the VFS and Linux kernel. =


As a side note, were you using a slightly less harsh tone, you'd
probably be help people being less reluctant to discuss those points
more deeply.

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
