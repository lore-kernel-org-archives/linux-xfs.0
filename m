Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BHQTdC143748 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 11:26:29 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6AA115D2B4E
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 09:25:53 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id fyxJutaeGmWIYXJH for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2009 09:25:53 -0800 (PST)
Message-ID: <49930A1B.7010905@sandeen.net>
Date: Wed, 11 Feb 2009 11:25:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: rfc 1/2: specfile: use rpm macros where possible
References: <alpine.LSU.2.00.0902111802320.25232@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0902111802320.25232@fbirervta.pbzchgretzou.qr>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

Jan Engelhardt wrote:
> parent d8a0f148be5b5ea67ee84c61201e98d345c14eda (v{3.0.0})
> commit c32f9b41de79a420e0896d2d4321ce74235d26ce
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Feb 11 17:52:53 2009 +0100
> 
> specfile: use rpm macros where possible
> 
> This way less places need to be changes (when a developer decides
> to change it..) after the placeholders have been substituted.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---

Fine by me, though I never use the specfile (who does?)

I figure most distros have their own specfile to accomodate
distro-specific policies, macros, etc.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
