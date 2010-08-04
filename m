Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o748oLfs025729 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 03:50:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5741E11CC89B
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 01:58:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EsorJ973X2q2kO8D for
	<xfs@oss.sgi.com>; Wed, 04 Aug 2010 01:58:43 -0700 (PDT)
Date: Wed, 4 Aug 2010 04:50:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Message-ID: <20100804085039.GA11671@infradead.org>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100804073546.GA7494@comet.dominikbrodowski.net>
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
To: Dominik Brodowski <linux@dominikbrodowski.net>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 09:35:46AM +0200, Dominik Brodowski wrote:
> How can I best track down the cause of the performance problem, 
> a) without rebooting too often, and
> b) without breaking up the setup specified above (production system)?

So did you just upgrade the system from an earlier kernel that did not
show these problems?  Or did no one notice them before?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
