Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6FIBIB233529 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 09:18:12 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E8241A31D5A
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 07:18:11 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AahPYCE9xNXuMmEY for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 07:18:11 -0800 (PST)
Date: Tue, 6 Dec 2011 10:18:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: check if qa user can execute commands
Message-ID: <20111206151809.GA15526@infradead.org>
References: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
	<20111206151300.GA11874@infradead.org>
	<4EDE31DD.3000401@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EDE31DD.3000401@jan-o-sch.net>
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
To: Jan Schmidt <mail@jan-o-sch.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>, xfs@oss.sgi.com

On Tue, Dec 06, 2011 at 04:16:45PM +0100, Jan Schmidt wrote:
> I agree. I saw this and thought I'd adapt the (sometimes strange)
> predominant bash programming style:

Maybe the IRIX su command didn't support -c.  I'll put your patch in
as-is.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
