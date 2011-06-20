Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5KEnjVM156672 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 09:49:46 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F0514E34ED
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 07:49:44 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id N79n5TFp2zZWaXrT for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2011 07:49:44 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5KEbrco018680
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 08:37:53 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5KEnQUL157076 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 08:49:30 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5K8mrYi032633
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 02:48:55 -0600
Message-ID: <4DFF5DEF.5040709@linux.vnet.ibm.com>
Date: Mon, 20 Jun 2011 07:49:19 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 v5] XFS TESTS: Expand 252 punch hole test
References: <4DED63DE.1070000@vnet.ibm.com>
	<20110620090754.GA27583@infradead.org>
In-Reply-To: <20110620090754.GA27583@infradead.org>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Allison Henderson <achender@vnet.ibm.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 06/20/2011 02:07 AM, Christoph Hellwig wrote:
> This actually broke 242 due to the new output from the new tests for me.
>
> Next time please do a full xfsqa run before submitting patches.
>

Ah, sorry about that, I will remember to run the whole xfsqa from now 
on. I think I have another set I submitted last night that I need to do 
that with too. I will get it fixed up and resent.

Allison Henderson




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
