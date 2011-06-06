Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p56Hfqq3241457 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 12:41:52 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3A561E3FDE3
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2011 10:41:51 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id bsahIFHLiYH1GNxr for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2011 10:41:51 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p56HLTRA009057
	for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 13:21:29 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p56Hfi5B446596 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 13:41:45 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p56HfimR002765 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 13:41:44 -0400
Message-ID: <4DED1155.4060503@vnet.ibm.com>
Date: Mon, 06 Jun 2011 10:41:41 -0700
From: Allison Henderson <achender@vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: Fwd: [XFSTEST Add Fallocate Punch Hole Tests 1/3 v4] Add Punch
	Hole to FSX
References: <4DE93268.90007@linux.vnet.ibm.com>
	<20110606150323.GB22236@infradead.org>
In-Reply-To: <20110606150323.GB22236@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Allison Henderson <achender@linux.vnet.ibm.com>

On 06/06/2011 08:03 AM, Christoph Hellwig wrote:
> Btw, you mails are basically unreadable to me.  There doesn't seem to be
> any threading context, and they all have your reply on top with a full
> quote.  Please try again with a submission from a saner mailer, and all
> important context information included in the [PATCH 0/n] mail.

Sorry about that, does this reply look better?  I realized that I needed 
to send the patch to more lists than just xfs, so I forwarded the set 
and the discussions.  I think the forwarding might have been what broke 
the threading, and I can turn off the full quote.  If this reply looks 
ok, I can resend the set and just collapse down the questions into a 
[PATCH 0/n] email.  Thx!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
