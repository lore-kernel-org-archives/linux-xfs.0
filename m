Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKFO2L6183097 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 09:24:02 -0600
Message-ID: <50ABA10F.2030809@sgi.com>
Date: Tue, 20 Nov 2012 09:26:07 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: get return value in seek_sanity_test
References: <1350825309-30733-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1350825309-30733-1-git-send-email-wenqing.lz@taobao.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "wenqing.lz" <gnehzuil.liu@gmail.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 10/21/12 08:15, wenqing.lz wrote:
> From: Zheng Liu<wenqing.lz@taobao.com>
>
> In seek_sanity_test getting return value is missing.  Thus we couldn't get the
> result unless someone read the log file (e.g. # 285).
>
> CC: Jeff Liu<jeff.liu@oracle.com>
> Signed-off-by: Zheng Liu<wenqing.lz@taobao.com>
> ---
> v2<- v1:
> 	* put return value check below the run_test()


This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests 
master branch, commit 7eab7e.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
