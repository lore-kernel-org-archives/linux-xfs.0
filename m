Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p55GO8Kw167864
	for <linux-xfs@oss.sgi.com>; Sun, 5 Jun 2011 11:24:08 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82C595186D5
	for <linux-xfs@oss.sgi.com>; Sun,  5 Jun 2011 09:24:06 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id OkOzJVyV71lP0AEM
	for <linux-xfs@oss.sgi.com>; Sun, 05 Jun 2011 09:24:06 -0700 (PDT)
Message-ID: <4DEBAD9F.5020009@dermichi.com>
Date: Sun, 05 Jun 2011 18:23:59 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: altering defaults
References: <8762onaq19.fsf@psinom.home>
In-Reply-To: <8762onaq19.fsf@psinom.home>
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
To: prad <prad@towardsfreedom.com>
Cc: linux-xfs@oss.sgi.com

Hi Prad!
> on the other hand, i've also come across webpages which say don't mess
> around! keep the defaults as they are unless you are absolutely sure
> that changing it suits your purpose and know why.
> 
I would do it exactly that way. XFS works reasonably well for all
ordinary things with the defaults (under the assumption that you are
using a reasonably up-to-date version of xfsprogs i.e. mkfs.xfs) and you
shouldn't fiddle with them unless you have very good reasons doing so.
Considering your current load on the server it shouldn't matter at all
and staying with the defaults is also a good way to ensure people will
be able to reproduce problems and help you in case you run into problems.

Just my 2cents

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
