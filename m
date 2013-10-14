Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7EF4B7F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:08:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A3D8304064
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 13:08:34 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KCoIQV0qvnLqu28c for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 13:08:32 -0700 (PDT)
Date: Tue, 15 Oct 2013 07:08:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair deletes files after power cut
Message-ID: <20131014200830.GL4446@dastard>
References: <345BE8CDF5F1514CB9B5CB3FFFA9B65920197D@xmb-aln-x14.cisco.com>
	<20130815000225.GH6023@dastard>
	<345BE8CDF5F1514CB9B5CB3FFFA9B6590145CD39@xmb-aln-x14.cisco.com>
	<345BE8CDF5F1514CB9B5CB3FFFA9B6590A8FEA5D@xmb-aln-x14.cisco.com>
	<20131009200615.GE4446@dastard>
	<345BE8CDF5F1514CB9B5CB3FFFA9B6590A8FF1DF@xmb-aln-x14.cisco.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <345BE8CDF5F1514CB9B5CB3FFFA9B6590A8FF1DF@xmb-aln-x14.cisco.com>
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
Cc: "Roee Friedman (rfriedma)" <rfriedma@cisco.com>, "Danny Shavit (dashavit)" <dashavit@cisco.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Oct 14, 2013 at 01:10:39PM +0000, Semion Zak (sezak) wrote:
> Hello Dave,
> 
> What should be done to deliver the patch?

The repair patch really just needs review and testing, but fixing
the kernel side of things is more complex and I'm not sure what is
needed there yet...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
