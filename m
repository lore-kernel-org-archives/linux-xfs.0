Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 228C47F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 13:51:14 -0500 (CDT)
Message-ID: <519287BF.3070704@sgi.com>
Date: Tue, 14 May 2013 13:51:43 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: add _require_seek_data_hole to check seek
	data/hole
References: <1368350670-9499-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1368350670-9499-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 05/12/2013 04:24 AM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> In xfstest 285/286 we don't check whether the target file system
> supports seek data/hole operation or not.  Here _require_seek_data_hole
> is defined to do this work.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Rich Johnston <rjohnston@sgi.com>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
