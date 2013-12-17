Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F0847F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 10:40:00 -0600 (CST)
Message-ID: <52B07E5B.4090302@sgi.com>
Date: Tue, 17 Dec 2013 10:39:55 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: set umask to avoid spurious generic/314 test
	failures
References: <20130921211735.GC7855@wallace>
In-Reply-To: <20130921211735.GC7855@wallace>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Whitney <enwlinux@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

This patch has been committed.

Thanks
--Rich

commit d0b5b6f9a8ccdb1279f319866e4540e8a05ac7c4
Author: Eric Whitney <enwlinux@gmail.com>
Date:   Sat Sep 21 21:17:35 2013 +0000

     xfstests: set umask to avoid spurious generic/314 test failures

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
