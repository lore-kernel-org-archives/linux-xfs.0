Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9O9EFJZ061733 for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 04:14:16 -0500
Date: Mon, 24 Oct 2011 05:14:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] xfstests: add new quota stress test
Message-ID: <20111024091412.GA3557@infradead.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
	<1319020189-13584-9-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319020189-13584-9-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: jack@suse.cz, xfs@oss.sgi.com, hch@infradead.org, aelder@sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Same comment about the subject as the previous one.

Also please use su as xfstest currently doesn't use and require sudo.

Also please use $qa_user instead of using fsgqa directly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
