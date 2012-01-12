Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CHTvWc008652 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 11:29:57 -0600
Message-ID: <4F0F1897.7040701@sgi.com>
Date: Thu, 12 Jan 2012 11:29:59 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 278: Ensure lost+found is not created with	wrong
	link count (V4)
References: <1326377187-27344-1-git-send-email-cmaiolino@redhat.com>
	<20120112144534.GB1798@andromeda.usersys.redhat.com>
In-Reply-To: <20120112144534.GB1798@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 01/12/12 08:45, Carlos Maiolino wrote:
> Mark, can you test it and see if the statement I used to send repair
> output to $seq.full will work on bash3? I haven't any system here using
> bash 3.
>
> Thanks

Works under bash3 and bash4. Thank-you,

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
