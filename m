Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FJGmXS090979 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 13:16:49 -0600
Date: Sun, 15 Feb 2009 14:16:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix off by one error in page_region_mask()
Message-ID: <20090215191614.GA862@infradead.org>
References: <49378B60.1060603@sgi.com> <20081222085354.GC24795@infradead.org>
	<49502F91.4050406@sgi.com> <49742371.2000806@sgi.com>
	<20090122222539.GA9643@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122222539.GA9643@infradead.org>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jan 22, 2009 at 05:25:39PM -0500, Christoph Hellwig wrote:
> On Mon, Jan 19, 2009 at 05:53:37PM +1100, Lachlan McIlroy wrote:
> > Lachlan McIlroy wrote:
> > > Christoph Hellwig wrote:
> > >> Did you guys come to a conclusion in your discussions?
> > >>
> > > No conclusion, well nothing that resulted in an ack.
> > 
> > Was anyone okay with this fix?
> 
> I think it's okay to go.  It fixes the one off so it's go.
> 
> The code is still a very hard to understand mess, but that's not what
> the patch was supposed to fix..

Any reason this isn't in yet?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
