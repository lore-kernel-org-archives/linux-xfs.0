Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6O7EB21196655 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 02:14:12 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request xfs_is_delayed_page
Date: Sun, 24 Jul 2011 09:14:03 +0200
References: <4E289228.4000208@gmail.com>
In-Reply-To: <4E289228.4000208@gmail.com>
MIME-Version: 1.0
Message-Id: <201107240914.04145.maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
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
To: =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Cc: xfs-masters@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On czwartek, 21 lipca 2011 o 22:55:04 T=F6r=F6k Edwin wrote:
> Hi,
> =

> Just got this BUG in my dmesg:
> [47504.938446] BUG: unable to handle kernel paging request at
> ffff884058ec3270 [47504.938488] IP: [<ffffffff8127baf1>]
[...]

2.6.39 works OK?. It is regression?

Regards
-- =

Maciej Rutecki
http://www.maciek.unixy.pl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
