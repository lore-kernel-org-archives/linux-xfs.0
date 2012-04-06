Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3660bY6134684 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 01:00:37 -0500
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	6XxMtqTcBBuPD376 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Apr 2012 23:00:36 -0700 (PDT)
Received: by ggni4 with SMTP id i4so1540202ggn.26
	for <xfs@oss.sgi.com>; Thu, 05 Apr 2012 23:00:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
	<4F776492.4070600@hardwarefreak.com>
	<CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
	<4F77D0B2.8000809@hardwarefreak.com>
	<CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
	<CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com>
	<CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com>
	<CALFpzo5aKM2y_stDR14PNYMHEcq5CEptuFiXrvcCpXTzSQmAxw@mail.gmail.com>
	<4F792154.5020006@hardwarefreak.com>
	<CACwgYDPsZSEhuqNP8YgAksEq9BB6YOS1Q8jGx2J7DCrrOh_JQw@mail.gmail.com>
	<CACwgYDOtCoVF-p+KKqPYxHhA4vWF78Ueecx9hcVWLoyxFWzV9Q@mail.gmail.com>
	<4F7E0842.6090004@hardwarefreak.com>
	<CACwgYDMEpFqJhtUGeRg4hvux3GigNRnA--V18DwdyUvJpY434w@mail.gmail.com>
	<CACwgYDPur_8sO-BhhP-ggEmPCGa5ddsCcmSDfCuhD9OgiwGRyw@mail.gmail.com>
Date: Fri, 6 Apr 2012 14:00:35 +0800
Message-ID: <CA+res+RR5iAZsEY8G21YkQn+p_8EYSFvu4+H1SK=HXshOcS-4g@mail.gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
From: Jack Wang <jack.wang.usish@gmail.com>
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
To: daobang wang <wangdb1981@gmail.com>
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>, stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

dXNpbmcgYmlnZ2VyIGlub2RlIHNpemUgb3IgaW5vZGU2NCBkb2VzIGhlbHA/CgpTbyB5b3VyIGVu
dmlyb25tZW50IGlzIE5WUiBzb2Z0d2FyZSBydW5uaW5nIGluIExpbnV4ICwxMDArIEQxIHN0cmVh
bWVyCmRpcmVjdGx5IHdyaXRlIHRvIGZpbGVzeXN0ZW0gb24gdG9wIG9mIDE2IFNBVEEgZGlza3Mg
KHdpdGggcmFpZDUgYW5kCnZnKT8KCjIwMTIvNC82IGRhb2Jhbmcgd2FuZyA8d2FuZ2RiMTk4MUBn
bWFpbC5jb20+Ogo+IFRoZXJlIGlzIGFub3RoZXIgaXNzdWUsIGkgdXBkYXRlZCB4ZnNwcm9nIGZy
b20gMi4xMC4xIHRvIDMuMS41LCBhbmQKPiBmb3VuZCBpIGNvdWxkIG5vdCBtYWtlIHRoZSB4ZnMg
ZmlsZXN5c3RlbSB3aGVuIHRoZSBsb2dpY2FsIHZvbHVtZSBzaXplCj4gbGFyZ2UgdGhhbiA4VEIg
d2l0aCBjb21tYW5kIG1rZnMueGZzIC1mIC1pIHNpemU9NTEyCj4gL2Rldi92Zyt2ZzAwKzIwMTIw
NDA2MTAxODUwL2x2K254eCtsdjAwMDAsIHRoaXMgY29tbWFuZCBzZWVtcyBoYW5nLCBpdAo+IGRp
ZCBub3QgcmV0dXJuIGZvciBhIGxvbmcgdGltZSwgaXMgdGhlcmUgYW55IHBhcmFtZXRlciBpIHNo
b3VsZAo+IGFkanVzdD8KPgo+IFRoYW5rIHlvdSB2ZXJ5IG11Y2gKPgo+IEJlc3QgUmVnYXJkcywK
PiBEYW9iYW5nIFdhbmcuCj4KPiBPbiA0LzYvMTIsIGRhb2Jhbmcgd2FuZyA8d2FuZ2RiMTk4MUBn
bWFpbC5jb20+IHdyb3RlOgo+PiBIaSBBbGwsCj4+Cj4+IMKgIMKgIEkgaGF2ZSBmb3VuZCB0aGUg
c29sdXRpb24sIGkgdXBkYXRlZCB0aGUgeGZzcHJvZ3MgZnJvbSAyLjEwLjEgdG8KPj4gMy4xLjUs
IGFuZCBjb3VsZCByZXBhaXIgaXQsIFRoYW5rcy4KPj4KPj4gQmVzdCBXaXNoZXMsCj4+IERhb2Jh
bmcgV2FuZy4KPj4KPj4gT24gNC82LzEyLCBTdGFuIEhvZXBwbmVyIDxzdGFuQGhhcmR3YXJlZnJl
YWsuY29tPiB3cm90ZToKPj4+IE9uIDQvNS8yMDEyIDE6NDggQU0sIGRhb2Jhbmcgd2FuZyB3cm90
ZToKPj4+PiBIaSBzdGFuLAo+Pj4+Cj4+Pj4gwqAgwqAgwqBJIGR1cGxpY2F0ZWQgdGhlIGlucHV0
L291dHB1dCBlcnJvciBpc3N1ZSwgYWJvdXQgdGhlIGRldGFpbAo+Pj4+IG9wZXJhdGlvbnMgYW5k
IGxvZ3MsIHBsZWFzZSBzZWUgdGhlIGF0dGFjaG1lbnRzLCBJcyB0aGVyZSBhbnkgd2F5IHRvCj4+
Pj4gZml4IHRoaXM/IHRoYW5rcyEKPj4+Pgo+Pj4+IEJlc3QgUmVnYXJkcywKPj4+PiBEYW9iYW5n
IFdhbmcuCj4+Pgo+Pj4KPj4+IFRoZXNlIGZpaWxlc3lzdGVtIGlzc3VlcyBoYXZlIG5vdGhpbmcg
dG8gZG8gd2l0aCBsaW51eC1yYWlkLiDCoEknbQo+Pj4gY29weWluZyB0aGUgWEZTIG1haWxpbmcg
bGlzdCB3aGljaCBpcyB3aGVyZSB0aGlzIGRpc2N1c3Npb24gc2hvdWxkIGJlCj4+PiB0YWtpbmcg
cGxhY2UgZnJvbSB0aGlzIHBvaW50IGZvcndhcmQuIMKgUGxlYXNlIHJlcGx5LXRvLWFsbCwgYW5k
IHBhc3RlCj4+PiB0aGUgb3V0cHV0IHlvdSBwcmV2aW91c2x5IGF0dGFjaGVkLCBidXQgaW5saW5l
IHRoaXMgdGltZS4KPj4+Cj4+PiBBbHNvLCBzaW5jZSB0aGUgWEZTIGZvbGtzIGFyZSB1bmZhbWls
aWFyIHdpdGggd2hhdCB5b3UncmUgZG9pbmcgdXAgdG8KPj4+IHRoaXMgcG9pbnQsIHBsZWFzZSBw
cm92aWRlIGEgYmFzaWMgZGVzY3JpcHRpb24gb2YgeW91ciBoYXJkd2FyZS9zdG9yYWdlCj4+PiBz
ZXR1cCwga2VybmVsIHZlcnNpb24sIG1kcmFpZCBjb25maWd1cmF0aW9uLCB4ZnNfaW5mbyBvdXRw
dXQgYXMgd2VsbCBhcwo+Pj4geW91ciBmc3RhYiBYRlMgbW91bnQgb3B0aW9ucywgYW5kIGEgZGVz
Y3JpcHRpb24gb2YgeW91ciB3b3JrbG9hZC4KPj4+Cj4+PiBNeSBiZXN0IGd1ZXNzIGF0IHRoaXMg
cG9pbnQgYXMgdG8gdGhlIGR1IGFuZCBscyBlcnJvcnMgaXMgdGhhdCB5b3VyCj4+PiBhcHBsaWNh
dGlvbiBpcyBub3QgYmVoYXZpbmcgcHJvcGVybHksIG9yIHlvdSdyZSBzdGlsbCBydW5uaW5nIHdp
dGggWEZTCj4+PiBiYXJyaWVycyBkaXNhYmxlZCwgd2hpY2gsIEkgc2F5IF9sb3VkbHlfIGZvciB0
aGUgMm5kIHRpbWUsIHlvdSBzaG91bGQKPj4+IE5PVCBkbyBpbiB0aGUgYWJzZW5jZSBvZiBCQldD
LCB3aGljaCB5b3Ugc3RhdGVkIHlvdSBkbyBub3QgaGF2ZS4KPj4+Cj4+PiAtLQo+Pj4gU3Rhbgo+
Pj4KPj4KPiAtLQo+IFRvIHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5l
ICJ1bnN1YnNjcmliZSBsaW51eC1yYWlkIiBpbgo+IHRoZSBib2R5IG9mIGEgbWVzc2FnZSB0byBt
YWpvcmRvbW9Admdlci5rZXJuZWwub3JnCj4gTW9yZSBtYWpvcmRvbW8gaW5mbyBhdCDCoGh0dHA6
Ly92Z2VyLmtlcm5lbC5vcmcvbWFqb3Jkb21vLWluZm8uaHRtbAoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
