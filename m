Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UKELEn070019 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 15:14:21 -0500
Received: from xmail.sgi.com (pv-excas2-dc21-nlb.corp.sgi.com [137.38.102.197])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B14BB304071
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 13:16:08 -0700 (PDT)
Message-ID: <509035F1.2040202@sgi.com>
Date: Tue, 30 Oct 2012 15:17:53 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] Add new standard loop handling functions
References: <1350549946-17192-1-git-send-email-tracek@redhat.com>
In-Reply-To: <1350549946-17192-1-git-send-email-tracek@redhat.com>
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
To: xfs@oss.sgi.com

On 10/18/2012 03:45 AM, Tomas Racek wrote:
> Add _create_loop_device and _destroy_loop_device to uniformly handle
> loopback devices.
>
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>   common.rc | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>

Tomas,
	Looks good.
--Rich

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
