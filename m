Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DKabYi215122 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 15:36:37 -0500
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id N6oQipncSXFjqfa3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Sep 2012 13:37:43 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 13 Sep 2012 16:37:41 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q8DKbYxm122910 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 16:37:35 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q8DKbX3V012311 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 17:37:34 -0300
Subject: Re: [RFC v6 PATCH 1/5] xfs: Remove incore use of XFS_OQUOTA_ENFD
	and XFS_OQUOTA_CHKD
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120913075613.GA32120@infradead.org>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120720230208.20477.49663.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120814224645.GQ2877@dastard>
	<1345676002.2260.0.camel@chandra-lucid.austin.ibm.com>
	<20120913075613.GA32120@infradead.org>
Date: Thu, 13 Sep 2012 15:37:31 -0500
Message-ID: <1347568651.2191.4720.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: xfs@oss.sgi.com

On Thu, 2012-09-13 at 03:56 -0400, Christoph Hellwig wrote:
> On Wed, Aug 22, 2012 at 05:53:22PM -0500, Chandra Seetharaman wrote:
> > will fix them as suggested.
> > 
> > Thanks for the review.
> 
> Any updates on reposting the series?

Sorry, got busy with other things. Will get back to this next week.

Chandra
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
