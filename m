Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04IgZAj163546 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 12:42:35 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	soPGay5AfNqayy8k for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 10:42:34 -0800 (PST)
Date: Wed, 4 Jan 2012 13:42:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 277: new test to verify on disk ctime update for chattr
Message-ID: <20120104184233.GC8131@infradead.org>
References: <4EF2AA17.40400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EF2AA17.40400@cn.fujitsu.com>
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
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Dec 22, 2011 at 11:55:03AM +0800, Li Zefan wrote:
> We had a bug in btrfs which can be triggered by this test.

Thanks, applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
