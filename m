Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EKlaEt127200 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 15:47:36 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86D8A11E1FD7
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 13:47:34 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id C2ExOhbnAmyJ13CG for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2011 13:47:34 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5EKJils022975
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 16:19:44 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5EKlYB2107744 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 16:47:34 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5EGlMUW032475 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 13:47:22 -0300
Subject: Re: xfstests test case 229 fails consistently
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <4DF7B90C.8050100@sandeen.net>
References: <1308077636.7661.476.camel@chandra-lucid.beaverton.ibm.com>
	<4DF7B90C.8050100@sandeen.net>
Date: Tue, 14 Jun 2011 13:47:33 -0700
Message-ID: <1308084453.7661.480.camel@chandra-lucid.beaverton.ibm.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-06-14 at 14:39 -0500, Eric Sandeen wrote:
> On 6/14/11 1:53 PM, Chandra Seetharaman wrote:
> > Hello All,
> > 
> > xfstests test case 229 fails consistently in my x84_64 system.
> > Only thing that is different between runs is the number of errors. 
> > Any suggestions on how to proceed with the debug. 
> > 
> > regards,
> > 
> > chandra
> > 
> 
> This one is known to fail.
> 
> http://oss.sgi.com/archives/xfs/2011-05/msg00237.html
> 
> "it's never passed. It's a placeholder to remind us how to
> reproduce a known problem that is difficult to fix."
> 
> -Eric

IIRC, correctly there are more tests like these (placeholder to remind
us how to reproduce ...). Would it be a good idea to list them in a file
and refer them in README ?

If yes, Can you provide me the list :), I promise a patch with the
changes.

chandra
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
