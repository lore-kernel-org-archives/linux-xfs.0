Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36MNDsq057891 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 17:23:14 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35FAC148A3A5
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 15:26:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Z6uUPGAqS91VCX6s for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 15:26:29 -0700 (PDT)
Date: Thu, 7 Apr 2011 08:26:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove unused 'bdi' variable in xfs_buf_readahead()
Message-ID: <20110406222624.GG31057@dastard>
References: <alpine.LNX.2.00.1104061311450.5855@pobox.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1104061311450.5855@pobox.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jiri Kosina <jkosina@suse.cz>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Alex Elder <aelder@sgi.com>

T24gV2VkLCBBcHIgMDYsIDIwMTEgYXQgMDE6MTU6NTBQTSAtMDcwMCwgSmlyaSBLb3NpbmEgd3Jv
dGU6Cj4gR2V0cyByaWQgb2YgCj4gCj4gCWZzL3hmcy9saW51eC0yLjYveGZzX2J1Zi5jOiBJbiBm
dW5jdGlvbiDigJh4ZnNfYnVmX3JlYWRhaGVhZOKAmToKPiAJZnMveGZzL2xpbnV4LTIuNi94ZnNf
YnVmLmM6NjYwOiB3YXJuaW5nOiB1bnVzZWQgdmFyaWFibGUg4oCYYmRp4oCZCj4gCj4gVGhlIHZh
cmlhYmxlIGhhcyBiZWVuIHVudXNlZCBzaW5jZSAwZTZlODQ3ZmZlICgieGZzOiBzdG9wIHVzaW5n
IHRoZSBwYWdlIAo+IGNhY2hlIHRvIGJhY2sgdGhlIGJ1ZmZlciBjYWNoZSIpCgpUaGVyZSdzIGFs
cmVhZHkgYSBwYXRjaCBpbiB0aGUgWEZTIHRyZWUgZm9yIHRoaXMuCgpDaGVlcnMsCgpEYXZlLgot
LSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
