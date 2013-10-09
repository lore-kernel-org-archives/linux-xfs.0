Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 39EA57F54
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:06:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 291E98F8074
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:06:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0bd3yBsNEUku0jwh for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 13:06:21 -0700 (PDT)
Date: Thu, 10 Oct 2013 07:06:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair deletes files after power cut
Message-ID: <20131009200615.GE4446@dastard>
References: <345BE8CDF5F1514CB9B5CB3FFFA9B65920197D@xmb-aln-x14.cisco.com>
	<20130815000225.GH6023@dastard>
	<345BE8CDF5F1514CB9B5CB3FFFA9B6590145CD39@xmb-aln-x14.cisco.com>
	<345BE8CDF5F1514CB9B5CB3FFFA9B6590A8FEA5D@xmb-aln-x14.cisco.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <345BE8CDF5F1514CB9B5CB3FFFA9B6590A8FEA5D@xmb-aln-x14.cisco.com>
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
To: "Semion Zak (sezak)" <sezak@cisco.com>
Cc: "xtv-fs-group-nds-dg(mailer list)" <xtv-fs-group-nds-dg@cisco.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Oct 09, 2013 at 09:55:39AM +0000, Semion Zak (sezak) wrote:
> Hello Dave,
> 
> Is the patch going to be implemented in the formal Linux code?

It needs to be. I've been busy with other stuff, so haven't done it
myself. I'll try to get to it soon, but if someone else wants to
pick it up sooner, then by all means....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
