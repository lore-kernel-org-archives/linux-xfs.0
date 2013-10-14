Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3D367F6C
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 08:10:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83CA2304048
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 06:10:42 -0700 (PDT)
Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	by cuda.sgi.com with ESMTP id NxFtA5mR8oUVdCUl (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 06:10:41 -0700 (PDT)
From: "Semion Zak (sezak)" <sezak@cisco.com>
Subject: RE: xfs_repair deletes files after power cut
Date: Mon, 14 Oct 2013 13:10:39 +0000
Message-ID: <345BE8CDF5F1514CB9B5CB3FFFA9B6590A8FF1DF@xmb-aln-x14.cisco.com>
References: <345BE8CDF5F1514CB9B5CB3FFFA9B65920197D@xmb-aln-x14.cisco.com>
	<20130815000225.GH6023@dastard>
	<345BE8CDF5F1514CB9B5CB3FFFA9B6590145CD39@xmb-aln-x14.cisco.com>
	<345BE8CDF5F1514CB9B5CB3FFFA9B6590A8FEA5D@xmb-aln-x14.cisco.com>
	<20131009200615.GE4446@dastard>
In-Reply-To: <20131009200615.GE4446@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "Roee Friedman (rfriedma)" <rfriedma@cisco.com>, "Danny Shavit (dashavit)" <dashavit@cisco.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello Dave,

What should be done to deliver the patch?

Thanks,

Semion

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Wednesday, October 09, 2013 11:06 PM
To: Semion Zak (sezak)
Cc: xfs@oss.sgi.com; xtv-fs-group-nds-dg(mailer list)
Subject: Re: xfs_repair deletes files after power cut

On Wed, Oct 09, 2013 at 09:55:39AM +0000, Semion Zak (sezak) wrote:
> Hello Dave,
> 
> Is the patch going to be implemented in the formal Linux code?

It needs to be. I've been busy with other stuff, so haven't done it myself. I'll try to get to it soon, but if someone else wants to pick it up sooner, then by all means....

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
