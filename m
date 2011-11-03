Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3CSPlF009013 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 07:28:26 -0500
Date: Thu, 3 Nov 2011 08:28:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfstests: add fiemap operation to fsstress
Message-ID: <20111103122822.GA8282@infradead.org>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-7-git-send-email-dmonakhov@openvz.org>
	<20111102195534.GB22500@infradead.org> <87zkgdy2fi.fsf@dmbot.sw.ru>
	<87ty6lxv1v.fsf@dmbot.sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ty6lxv1v.fsf@dmbot.sw.ru>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, aelder@sgi.com, hch@lst.de, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 04:14:04PM +0400, Dmitry Monakhov wrote:
> i've stuck immediately on first test ;(.
> on my kernel 107'th test always failed (commit: 73a57c642cdfa660
> "1.1.0 release"), is it expected? Which xfs-tree and commit should i use?

106 and 107 have been failing basically forever - that's why they aren't
part of the auto group. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
