Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 16:16:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5QNGGtL002191
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 16:16:19 -0700
Date: Wed, 27 Jun 2007 09:15:55 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Message-ID: <20070626231555.GP31489@sgi.com>
References: <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625132810.GA1951@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, Jun 25, 2007 at 06:58:10PM +0530, Amit K. Arora wrote:
> 2) The above new patches (4/7 and 7/7) are based on the dicussion
>    between Andreas Dilger and David Chinner on the mode argument,
>    when later posted a man page on fallocate.

Can you include the man page in this patch set, please? That
way it can be kept up to date with the rest of the patch set.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
