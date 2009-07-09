Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n69D1IsO028956 for <xfs@oss.sgi.com>; Thu, 9 Jul 2009 08:01:19 -0500
Received: from acsinet12.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD4E2149B832
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 06:08:56 -0700 (PDT)
Received: from acsinet12.oracle.com (acsinet12.oracle.com [141.146.126.234])
	by cuda.sgi.com with ESMTP id HEbXQtV5VAosvxIk for
	<xfs@oss.sgi.com>; Thu, 09 Jul 2009 06:08:56 -0700 (PDT)
Date: Thu, 9 Jul 2009 09:01:34 -0400
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
Message-ID: <20090709130134.GH18008@think>
References: <20090707193015.7DCD.A69D9226@jp.fujitsu.com>
	<20090707104440.GB21747@infradead.org>
	<20090709110342.2386.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090709110342.2386.A69D9226@jp.fujitsu.com>
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
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, linux-mm@kvack.org, Olaf Weber <olaf@sgi.com>, xfs mailing list <xfs@oss.sgi.com>

On Thu, Jul 09, 2009 at 11:04:32AM +0900, KOSAKI Motohiro wrote:
> > On Tue, Jul 07, 2009 at 07:33:04PM +0900, KOSAKI Motohiro wrote:
> > > At least, I agree with Olaf. if you got someone's NAK in past thread,
> > > Could you please tell me its url?
> > 
> > The previous thread was simply dead-ended and nothing happened.
> > 
> 
> Can you remember this thread subject? sorry, I haven't remember it.

This is the original thread, it did lead to a few different patches
going in, but the nr_to_write change wasn't one of them.

http://kerneltrap.org/mailarchive/linux-kernel/2008/10/1/3472704/thread

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
