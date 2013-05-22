Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E61EF7CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 14:01:10 -0500 (CDT)
Message-ID: <519D161B.2020008@sgi.com>
Date: Wed, 22 May 2013 14:01:47 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: generic/258 questions (mount issue)...
References: <519C14A1.8000009@gmail.com> <20130522012620.GA29466@dastard>
	<519C3596.7080109@gmail.com>
In-Reply-To: <519C3596.7080109@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 05/21/2013 10:03 PM, Michael L. Semon wrote:

>
> This is my first attempt at doing a `git format-patch --stdout`.
> Hopefully, this is somewhat more presentable to git.  Comments and
> brow-beating are welcome.
>
> Thanks!
>
> Michael

Thanks for the patch Michael, it has been committed:

commit f4ba26dcdc64a206d73d47cf054ecb2742867c55
Author: Michael L. Semon <mlsemon35@gmail.com>
Date:   Wed May 22 13:50:59 2013 -0500

     xfstests: Change mount method for generic/258

The only other suggestion would be to make your email subject match the 
patch name and starting with which part of xfs it is submitted for 
(xfs:, xfstests:, xfsprogs:, xfsdump:, xfsdmapi:. etc) i.e.

Subject: [PATCH]  xfstests: Change mount method for generic/258

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
