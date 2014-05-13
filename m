Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FA9B7F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 08:06:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D465A8F8054
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 06:06:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id V38csoWbJtt7fNrk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 06:06:21 -0700 (PDT)
Message-ID: <53721882.50005@oracle.com>
Date: Tue, 13 May 2014 21:05:06 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 9/9] xfs: list_lru_init returns a negative error
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
	<1399971373-6242-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-10-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com


On 05/13 2014 16:56 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> And we don't invert it properly when initialising the dquot lru
> list.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
