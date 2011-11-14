Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAECokK1210278 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 06:50:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8FB924ADE6
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 04:50:45 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NBnpNqNFbYzMBQLT for <xfs@oss.sgi.com>;
	Mon, 14 Nov 2011 04:50:45 -0800 (PST)
Date: Mon, 14 Nov 2011 07:50:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Message-ID: <20111114125044.GA9802@infradead.org>
References: <4E887D7F.2010306@oracle.com>
	<20111114102444.GA27791@infradead.org>
	<4EC10DE8.6030607@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EC10DE8.6030607@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 14, 2011 at 08:47:36PM +0800, Jeff Liu wrote:
> Hi Christoph,
> 
> On 11/14/2011 06:24 PM, Christoph Hellwig wrote:
> 
> > Just curious:  did you start looking into implementing
> > SEEK_DATA/SEEK_HOLE support?
> 
> I have misunderstood your previous response:
> 
> "Dave mentioned he had a basic implementation, he might have some code
> that you can improve on.?
> 
> So I am still waiting that now.

He mentioned that, but given that there was no folloup with code
I wouldn't expect it to appear anymore.

> But actually I have already wrote a patch at that time, I'll run a few
> tests and send it out for your guys review soon.

Thanks a lot!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
