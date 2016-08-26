Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 435207F2C
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 21:16:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0635A8F8039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:16:31 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pDrRp59XuWDP6PXW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:16:30 -0700 (PDT)
Subject: Re: [PATCH v10 0/3] fallocate for block devices
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <147216972158.7860.13484490862091226290.stgit@birch.djwong.org>
Date: Thu, 25 Aug 2016 22:15:52 -0400
In-Reply-To: <147216972158.7860.13484490862091226290.stgit@birch.djwong.org>
	(Darrick J. Wong's message of "Thu, 25 Aug 2016 17:02:01 -0700")
Message-ID: <yq1shtsb7hj.fsf@sermon.lab.mkp.net>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick,

Darrick> This is a redesign of the patch series that fixes various
Darrick> interface problems with the existing "zero out this part of a
Darrick> block device" code.  BLKZEROOUT2 is gone.

Looks good to me. Let's get this merged. Pretty please!

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
