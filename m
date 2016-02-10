Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A98829DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 21:24:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 320DE8F8040
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 19:24:08 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id KNGWWY9OagXK9vZu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 19:24:06 -0800 (PST)
Subject: Bug#766811: spurious library links
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.766811.B766811.14550744297682@bugs.debian.org>
Date: Tue, 9 Feb 2016 22:20:23 -0500 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
In-Reply-To: <20160210031703.GA28092@bongo.bofh.it>
References: <20141026004825.GA27863@bongo.bofh.it>
	<20160124151308.GA7620@jwilk.net>
	<20160206005821.GA11551@bongo.bofh.it>
	<20160206132241.GA2869@jwilk.net>
	<20160210031703.GA28092@bongo.bofh.it>
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>, 766811@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Marco d'Itri <md@linux.it>
Cc: Jakub Wilk <jwilk@debian.org>, 766811@bugs.debian.org



----- Original Message -----
> [..]
> Right. Nathan, this code path is not used on Red Hat and SuSE, which
> already implemented a merged /usr, and it has always been wrong on
> Debian: I think it should just be removed from the upstream package.
> Should I NMU?

Please go right ahead Marco - many thanks!

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
