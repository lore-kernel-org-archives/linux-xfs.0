Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PD3AnE004743 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 08:03:10 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B1D12EE56E
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 06:05:11 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id GJuAeviXoNG4qJrL for
	<xfs@oss.sgi.com>; Sun, 25 Apr 2010 06:05:11 -0700 (PDT)
Date: Sun, 25 Apr 2010 15:04:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100425150454.29332472@galadriel.home>
In-Reply-To: <201004250030.40867.hpj@urpla.net>
References: <201004050049.17952.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net>
	<20100424232320.71f764eb@galadriel.home>
	<201004250030.40867.hpj@urpla.net>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Nick Piggin <npiggin@suse.de>, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Le Sun, 25 Apr 2010 00:30:40 +0200 vous =E9criviez:

> I guess, you're not on this specific openSUSE git version of
> 2.6.32.11 (e.g. the preparation for SP1 of SLE11), which, as usual,
> carries a lot of stuff from later kernels.

No, I always use pristine unpatched kernel.org releases, no SELinux, no
nothing. Just another confirmation I should go on this way :)

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
