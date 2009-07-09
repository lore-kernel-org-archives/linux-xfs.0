Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n69242bR000346 for <xfs@oss.sgi.com>; Wed, 8 Jul 2009 21:04:02 -0500
Received: from fgwmail7.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDD2F1B4C16D
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2009 19:04:36 -0700 (PDT)
Received: from fgwmail7.fujitsu.co.jp (fgwmail7.fujitsu.co.jp [192.51.44.37])
	by cuda.sgi.com with ESMTP id xqXE2Fpllrjb4AqV for
	<xfs@oss.sgi.com>; Wed, 08 Jul 2009 19:04:36 -0700 (PDT)
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id
	n6924ZRr014807
	for <xfs@oss.sgi.com> (envelope-from kosaki.motohiro@jp.fujitsu.com);
	Thu, 9 Jul 2009 11:04:35 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id B068845DE7D
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 11:04:34 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8124B45DE60
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 11:04:34 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 3C613E08001
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 11:04:34 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id D5917E08003
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 11:04:33 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
In-Reply-To: <20090707104440.GB21747@infradead.org>
References: <20090707193015.7DCD.A69D9226@jp.fujitsu.com>
	<20090707104440.GB21747@infradead.org>
Message-Id: <20090709110342.2386.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Date: Thu,  9 Jul 2009 11:04:32 +0900 (JST)
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, kosaki.motohiro@jp.fujitsu.com, xfs mailing list <xfs@oss.sgi.com>, linux-mm@kvack.org, Olaf Weber <olaf@sgi.com>, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>

> On Tue, Jul 07, 2009 at 07:33:04PM +0900, KOSAKI Motohiro wrote:
> > At least, I agree with Olaf. if you got someone's NAK in past thread,
> > Could you please tell me its url?
> 
> The previous thread was simply dead-ended and nothing happened.
> 

Can you remember this thread subject? sorry, I haven't remember it.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
