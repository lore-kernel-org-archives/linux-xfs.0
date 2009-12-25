Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBPJWfl8209449 for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 13:32:41 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 050A4127B96
	for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 11:33:25 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id yDWxiGh75hwP3w0V for
	<xfs@oss.sgi.com>; Fri, 25 Dec 2009 11:33:25 -0800 (PST)
Date: Fri, 25 Dec 2009 11:32:58 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
In-Reply-To: <alpine.DEB.2.01.0912251054200.3483@bogon.housecafe.de>
Message-ID: <alpine.DEB.2.01.0912251126080.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
	<20091225163341.GE32757@thunk.org>
	<alpine.DEB.2.01.0912251054200.3483@bogon.housecafe.de>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: tytso@mit.edu
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, Larry McVoy <lm@bitmover.com>, ext-users <ext3-users@redhat.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

On Fri, 25 Dec 2009 at 10:56, Christian Kujau wrote:
> Thanks for the hint, I could find sys/vm/drop-caches documented in 
------------------------------^ not, was what I meant to say,
but it's all there, as "drop_caches" in Documentation/sysctl/vm.txt

Christian.

> Documentation/ but it's good to know there's a way to flush all these 
> caces via this knob. Maybe I should add this to those "genric" tests to be 
> more comparable to the other benchmarks.
-- 
BOFH excuse #129:

The ring needs another token

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
