Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B5F97CA1
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 19:47:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2D2EAC001
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 17:47:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wZxPBPt2xPBImeIb for <xfs@oss.sgi.com>;
	Tue, 03 May 2016 17:47:45 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id AB31B9E
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 19:47:45 -0500 (CDT)
Subject: Re: [PATCH 13/19] mkfs: encode conflicts into parsing table
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-14-git-send-email-jtulak@redhat.com>
	<a3f5f830-27e9-26b4-9ffd-1fbdf5ca7952@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b4d23c99-133e-fd05-9a38-589e306d1b20@sandeen.net>
Date: Tue, 3 May 2016 19:47:45 -0500
MIME-Version: 1.0
In-Reply-To: <a3f5f830-27e9-26b4-9ffd-1fbdf5ca7952@sandeen.net>
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
To: xfs@oss.sgi.com

Dammit, ignore this, it was supposed to be for 03/19.

I swear this patchset is cursed ;)

On 5/3/16 6:39 PM, Eric Sandeen wrote:
> Sorry, updated fixup patch; missed removal of "\" chars:
> 
> 
> 
> Remove now-encoded conflict under case L_FILE
> 
> The .conflicts handle this now, no need to keep it around.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
