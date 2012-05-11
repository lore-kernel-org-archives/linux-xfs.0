Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BGk8dk074388 for <xfs@oss.sgi.com>; Fri, 11 May 2012 11:46:08 -0500
Date: Fri, 11 May 2012 11:50:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: file corruption issue
Message-ID: <20120511165012.GC16099@sgi.com>
References: <51509.110.174.53.110.1336699622.squirrel@boosthardware.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51509.110.174.53.110.1336699622.squirrel@boosthardware.com>
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
To: Patrick Shirkey <pshirkey@boosthardware.com>
Cc: xfs@oss.sgi.com

On Fri, May 11, 2012 at 03:27:02AM +0200, Patrick Shirkey wrote:
> I have some HP machines running centos:
> 
> kernel 2.6.32-042stab049.6
> AMD Opteron(tm) Processor 6180 SE
> RAM:   528 GB
> RAID bus controller: Hewlett-Packard Company Smart Array G6 controllers
> 
> We have experienced some kernel crashes due to a kernel bug with
> interleaving ram on this hardware which require hard reset of the
> machines.
> 
> After reboot we are finding that there is severe file corruption on the
> xfs file system where TBs of readonly databases are getting partially or
> fully truncated.
> 
> Has anyone come across this or similar?

This rings a bell for me but I can't be certain.  Could you provide a metadump?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
